//
//  Surface Transmit.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation

extension MIDI.HUI.Surface {
    
    /// HUI ping message transmit to host.
    /// It is not necessary to call this manually. The `Surface` object will handle ping replies automatically.
    public func transmitPing() {
        
        midiOut(MIDI.HUI.kMIDI.kPingReplyToHostMessage)
        
    }
    
    /// Transmit switch state to host.
    /// - Parameters:
    ///   - zone: HUI zone number
    ///   - port: HUI port number
    ///   - state: State of switch or action
    internal func transmitSwitch(zone: MIDI.Byte,
                                 port:  MIDI.UInt4,
                                 state: Bool) {
        
        // set on off byte
        var portByte: MIDI.Byte = port.uInt8Value
        
        if state == true {
            portByte += 0x40
        }
        
        let event1 = MIDI.Event.cc(0x0F, value: .midi1(zone.toMIDIUInt7), channel: 0)
        let event2 = MIDI.Event.cc(0x2F, value: .midi1(portByte.toMIDIUInt7), channel: 0)
        
        midiOut(event1)
        midiOut(event2)
        
    }
    
    /// Transmit switch state to host.
    public func transmitSwitch(_ param: MIDI.HUI.Parameter,
                               state: Bool) {
        
        let zoneAndPort = param.zoneAndPort
        
        transmitSwitch(zone: zoneAndPort.zone,
                       port: zoneAndPort.port,
                       state: state)
        
    }
    
    /// Transmit fader level to host.
    /// - parameters:
    ///   - level: 0...16383
    ///   - channel: 0...7
    public func transmitFader(level: MIDI.UInt14,
                              channel: Int) {
        
        guard (0...16383).contains(level) else { return }
        guard (0x0...0x7).contains(channel) else { return }
        
        let msb = level.bytePair.msb.toMIDIUInt7
        let lsb = level.bytePair.lsb.toMIDIUInt7
        let channelHi = channel.toMIDIUInt7
        let channelLow = (channel + 0x20).toMIDIUInt7
        
        let event1 = MIDI.Event.cc(channelHi, value: .midi1(msb), channel: 0)
        let event2 = MIDI.Event.cc(channelLow, value: .midi1(lsb), channel: 0)
        
        midiOut(event1)
        midiOut(event2)
        
    }
    
    /// Transmit fader touch/release message to host.
    /// - parameters:
    ///   - isTouched: `true` sends touch message, `false` sends release message
    ///   - channel: 0...7
    public func transmitFader(isTouched: Bool,
                              channel: Int) {
        
        guard (0x0...0x7).contains(channel) else { return }
        
        let event1 = MIDI.Event.cc(0x0F, value: .midi1(channel.toMIDIUInt7), channel: 0)
        let event2 = MIDI.Event.cc(0x2F, value: .midi1(isTouched ? 0x40 : 0x00), channel: 0)
        
        midiOut(event1)
        midiOut(event2)
        
    }
    
    /// Sends a message that tells the host that the HUI device is powering on or off.
    public func transmitSystemReset() {
        
        midiOut(MIDI.HUI.kMIDI.kSystemResetMessage)
        
    }
    
}
