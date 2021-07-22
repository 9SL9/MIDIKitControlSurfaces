//
//  Parser.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

extension MIDI.HUI {
    
    /// HUI MIDI Message Parser
    public class Parser {
        
        // MARK: local state variables
        
        private var timeDisplay: [String] = []
        private var largeDisplay: [String] = []
        private var faderMSB: [MIDI.Byte] = []
        private var switchesZoneSelect: UInt8? = nil
        
        // MARK: handlers
        
        public typealias HUIEventHandler = ((Event) -> Void)
        
        /// Parser event handler that triggers when HUI events are received.
        public var huiEventHandler: HUIEventHandler?
        
        // MARK: - init
        
        public init(
            huiEventHandler: HUIEventHandler? = nil
        ) {
            
            self.huiEventHandler = huiEventHandler
            reset()
            
        }
        
        /// Resets the parser to original init state. (Handlers are unaffected.)
        public func reset() {
            
            timeDisplay = [String](repeating: " ", count: 8)
            
            largeDisplay = [String](repeating: MIDI.HUI.Surface.State.LargeDisplay.defaultStringComponent, count: 8)
            
            // HUI protocol (and the HUI hardware control surface) has only 8 channel faders.
            // Even though some control surface models have a 9th master fader
            // such as EMAGIC Logic Control and Mackie Control Universal,
            // when running in HUI mode, the master fader is disabled.
            faderMSB = [MIDI.Byte](repeating: 0, count: 8)
            
            switchesZoneSelect = nil
            
        }
        
    }
    
}

// MARK: ReceivesMIDIEvents

extension MIDI.HUI.Parser: ReceivesMIDIEvents {
    
    /// Process HUI MIDI message received from host
    public func midiIn(event: MIDI.Event) {
        
        // HUI ping-reply
        if event == MIDI.HUI.kMIDI.kPingFromHostMessage {
            // handler should send ping-reply to host
            huiEventHandler?(.pingReceived)
            return
        }
        
        switch event {
        case .sysEx(manufacturer: let mfr, data: let bytes):
            guard mfr == MIDI.HUI.kMIDI.kSysEx.kManufacturer else { return }
            parse(sysExContent: bytes)
            
        case .cc:
            parse(controlStatusMessage: event)
            
        case .polyAftertouch:
            parse(levelMetersMessage: event)
            
        default:
            break
        }
        
    }
    
}

// MARK: Parser

extension MIDI.HUI.Parser {
    
    private func parse(sysExContent data: [MIDI.Byte]) {
        
        // check for SysEx header
        guard data[safe: 0] == MIDI.HUI.kMIDI.kSysEx.kSubID1,
              data[safe: 1] == MIDI.HUI.kMIDI.kSysEx.kSubID2
        else { return }
        
        let dataAfterHeader = data
            .suffix(
                from: data.index(data.startIndex,
                                 offsetBy: 2)
            )
        
        guard dataAfterHeader.count > 0 else { return }
        
        switch dataAfterHeader.first {
        case MIDI.HUI.kMIDI.kDisplayType.smallByte:
            // 0x10 channel [4 chars]
            
            guard dataAfterHeader.count == 6 else {
                Log.debug("Received Small Display text MIDI message \(data.hex.stringValue(padTo: 2)) but length was not expected.")
                return
            }
            
            // channel can be 0-8 (0-7 = channel strips, 8 = Select Assign text display)
            let channel = dataAfterHeader[atOffset: 1]
            var newString = ""
            
            for byte in dataAfterHeader[atOffsets: 2...5] {
                newString += MIDI.HUI.kCharTables.smallDisplay[byte.int]
            }
            
            if channel.isContained(in: 0...7) {
                huiEventHandler?(.channelName(channelStrip: channel.int, text: newString))
            } else if channel == 8 {
                // ***** not storing local state yet - needs to be implemented
                
                // ***** should get folded into a master Select Assign callback
                huiEventHandler?(.selectAssignText(text: newString))
            } else {
                Log.debug("Small Display text message channel not expected: \(channel). Needs to be coded.")
            }
            
            return
            
        case MIDI.HUI.kMIDI.kDisplayType.largeByte:
            // 0x12 zone [10 chars]
            // it may be possible to receive multiple blocks in the same SysEx message (?), ie:
            // 0x12 zone [10 chars] zone [10 chars]
            // message length test: remove first byte (0x12), then see if remainder is divisible by 11
            guard (dataAfterHeader.count - 1) % 11 == 0 else {
                Log.debug("Received Large Display text MIDI message \(data.hex.stringValue(padTo: 2)) but length was not expected.")
                return
            }
            
            var largeDisplayData = dataAfterHeader[atOffsets: 1...dataAfterHeader.count-1]
            
            while largeDisplayData.count >= 11 {
                let zone = largeDisplayData[atOffset: 0].int
                var newString = ""
                let letters = largeDisplayData[atOffsets: 1...10]
                
                for letter in letters {
                    newString += MIDI.HUI.kCharTables.largeDisplay[letter.int] // ***** could get index overflow
                }
                largeDisplay[zone] = newString // update local state
                
                largeDisplayData = largeDisplayData.dropFirst(11)
            }
            
            huiEventHandler?(.largeDisplayText(components: largeDisplay))
            return
            
        case MIDI.HUI.kMIDI.kDisplayType.timeDisplayByte:
            guard dataAfterHeader.count > 0 else { return }
            let tcData: [Int] = dataAfterHeader[atOffsets: 1...dataAfterHeader.count-1].map { Int($0) }
            var i = 0
            
            for number in tcData {
                if number != Int(MIDI.HUI.kMIDI.kSysExEndByte) { // kind of a lazy workaround but it works
                    var lookupChar = ""
                    
                    if number < MIDI.HUI.kCharTables.timeDisplay.count {
                        // in lookup table bounds
                        lookupChar = MIDI.HUI.kCharTables.timeDisplay[number]
                    } else {
                        // not recognized
                        lookupChar = "?"
                        Log.debug("Timecode character code not recognized:",
                                  number.hex.stringValue, "(Int: \(number))")
                    }
                    
                    // update local state
                    timeDisplay[7 - i] = lookupChar
                    i += 1
                }
            }
            
            huiEventHandler?(.timeDisplayText(components: timeDisplay))
            return
            
        default:
            Log.debug("Header detected but subsequent message is not recognized:",
                      dataAfterHeader.hex.stringValue(padToEvery: 2))
            
        }
        
    }
    
    private func parse(controlStatusMessage event: MIDI.Event) {
        
        let data = event.rawBytes
        
        guard data[safe: 0] == MIDI.HUI.kMIDI.kControlStatus else { return }
        
        guard let dataByte1 = data[safe: 1],
              let dataByte2 = data[safe: 2]
        else { return }
        
        // Control Segment
        
        
        switch dataByte1 {
        case 0x00...0x07:
            // Channel Strip Fader level MSB
            
            let channel = dataByte1.hex.nibble(0).value.int
            
            faderMSB[channel] = dataByte2
            
        case 0x20...0x27:
            // Channel Strip Fader level LSB
            
            let channel = dataByte1.hex.nibble(0).value.int
            
            let msb = faderMSB[channel].uint16 << 7
            let lsb = dataByte2.uint16
            
            guard let level = (msb + lsb).midiUInt14Exactly else { return }
            
            huiEventHandler?(.faderLevel(channelStrip: channel, level: level))
            
        case 0x10...0x1B:
            // V-Pots
            
            let channel = (dataByte1 % 0x10).int
            let value = dataByte2.midiUInt7
            
            huiEventHandler?(.vPot(channelStrip: channel, value: value))
            
        case MIDI.HUI.kMIDI.kControlDataByte1.zoneSelectByte:
            // zone select (1st message)
            
            switchesZoneSelect = dataByte2
            
        case MIDI.HUI.kMIDI.kControlDataByte1.portOnOffByte:
            // port on, or port off (2nd message)
            
            defer { switchesZoneSelect = nil }
            
            let port = dataByte2.hex.nibble(0).value.midiUInt4
            var state: Bool
            
            switch dataByte2.hex.nibble(1).value {
            case 0x0:
                state = false
            case 0x4:
                state = true
            default:
                if let zone = switchesZoneSelect {
                    if let guess = MIDI.HUI.Parameter(zone: zone,
                                                      port: port)
                    {
                        Log.debug("Received message 2 of a switch command \(data.hex.stringValue(padTo: 2, prefix: true)) matching \(guess) but has unexpected state bit \(dataByte2.hex.nibble(1).stringValue(prefix: true)). Ignoring message.")
                    } else {
                        Log.debug("Received message 2 of a switch command \(data.hex.stringValue(padTo: 2, prefix: true)) but has unexpected state bit (\(dataByte2.hex.nibble(1).stringValue(prefix: true))). Additionally, could not guess zone and port pair name. Ignoring message.")
                    }
                } else {
                    Log.debug("Received message 2 of a switch command \(data.hex.stringValue(padTo: 2, prefix: true)) but has unexpected state bit (\(dataByte2.hex.nibble(1).stringValue(prefix: true))). Additionally, could not lookup zone and port name because zone select message was not received prior. Ignoring message.")
                }
                
                return
                
            }
            
            if let zone = switchesZoneSelect {
                huiEventHandler?(.switch(zone: zone, port: port, state: state))
                switchesZoneSelect = nil // reset zone select
            } else {
                Log.debug("Received message 2 of a switch command (\(data.hex.stringValue(padTo: 2, prefix: true)) port: \(port), state: \(state)) without first receiving a zone select message. Ignoring.")
            }
            
        default:
            Log.debug("Unrecognized HUI MIDI status 0xB0 data byte 1: \(dataByte1.hex.stringValue(padTo: 2, prefix: true)) in message: \(data.hex.stringValue(padTo: 2, prefix: true)).")
        }
        
    }
    
    private func parse(levelMetersMessage event: MIDI.Event) {
        
        let data = event.rawBytes
        
        guard data[safe: 0] == MIDI.HUI.kMIDI.kLevelMetersStatus else { return }
        
        guard let dataByte1 = data[safe: 1],
              let dataByte2 = data[safe: 2]
        else { return }
        
        let channel = dataByte1.int
        let sideAndValue = dataByte2 // encodes both side and value
        
        var side: MIDI.HUI.Surface.State.StereoLevelMeter.Side
        var level: Int
        
        if sideAndValue >= 0x10 {
            side = .right // right
            level = (sideAndValue % 0x10).int
        } else {
            side = .left // left
            level = sideAndValue.int
        }
        
        huiEventHandler?(.levelMeters(channelStrip: channel, side: side, level: level))
        
    }
    
}

extension RandomAccessCollection {
    
    /// Utility
    fileprivate func range(ofOffsets range: ClosedRange<Int>) -> ClosedRange<Index> {
        let inIndex = index(startIndex, offsetBy: range.lowerBound)
        let outIndex = index(startIndex, offsetBy: range.upperBound)
        return inIndex...outIndex
    }
    
    /// Utility
    fileprivate subscript(atOffsets range: ClosedRange<Int>) -> Self.SubSequence {
        let inIndex = index(startIndex, offsetBy: range.lowerBound)
        let outIndex = index(startIndex, offsetBy: range.upperBound)
        return self[inIndex...outIndex]
    }
    
    /// Utility
    fileprivate subscript(atOffset offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }
    
}
