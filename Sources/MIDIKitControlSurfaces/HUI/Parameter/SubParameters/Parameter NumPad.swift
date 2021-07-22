//
//  Parameter NumPad.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Number entry pad
    public enum NumPad: Equatable, Hashable {
        
        case num0
        case num1
        case num2
        case num3
        case num4
        case num5
        case num6
        case num7
        case num8
        case num9
        
        case period       // .
        case plus         // +
        case minus        // -
        case enter
        case clr          // clr
        case equals       // =
        case forwardSlash // /
        case asterisk     // *
        
    }
    
}

extension MIDI.HUI.Parameter.NumPad: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x13
        // Num Pad
        case .num0:          return (0x13, 0x0)
        case .num1:          return (0x13, 0x1)
        case .num4:          return (0x13, 0x2)
        case .num2:          return (0x13, 0x3)
        case .num5:          return (0x13, 0x4)
        case .period:        return (0x13, 0x5)
        case .num3:          return (0x13, 0x6)
        case .num6:          return (0x13, 0x7)
        
        // Zone 0x14
        // Num Pad
        case .enter:         return (0x14, 0x0)
        case .plus:          return (0x14, 0x1)
        
        // Zone 0x15
        // Num Pad
        case .num7:          return (0x15, 0x0)
        case .num8:          return (0x15, 0x1)
        case .num9:          return (0x15, 0x2)
        case .minus:         return (0x15, 0x3)
        case .clr:           return (0x15, 0x4)
        case .equals:        return (0x15, 0x5)
        case .forwardSlash:  return (0x15, 0x6)
        case .asterisk:      return (0x15, 0x7)
        
        }
        
    }
    
}

extension MIDI.HUI.Parameter.NumPad: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // Zone 0x13
        // Num Pad
        case .num0:          return ".num0"
        case .num1:          return ".num1"
        case .num4:          return ".num4"
        case .num2:          return ".num2"
        case .num5:          return ".num5"
        case .period:        return ".period"
        case .num3:          return ".num3"
        case .num6:          return ".num6"
        
        // Zone 0x14
        // Num Pad
        case .enter:         return ".enter"
        case .plus:          return ".plus"
        
        // Zone 0x15
        // Num Pad
        case .num7:          return ".num7"
        case .num8:          return ".num8"
        case .num9:          return ".num9"
        case .minus:         return ".minus"
        case .clr:           return ".clr"
        case .equals:        return ".equals"
        case .forwardSlash:  return ".forwardSlash"
        case .asterisk:      return ".asterisk"
        
        }

    }

}
