//
//  Parameter AutoMode.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Auto Mode (To the right of the channel strips)
    public enum AutoMode: Equatable, Hashable {
        
        case read
        case latch
        case trim
        case touch
        case write
        case off
        
    }
    
}

extension MIDI.HUI.Parameter.AutoMode: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x18
        // Auto Mode (To the right of the channel strips)
        case .trim:   return (0x18, 0x0)
        case .latch:  return (0x18, 0x1)
        case .read:   return (0x18, 0x2)
        case .off:    return (0x18, 0x3)
        case .write:  return (0x18, 0x4)
        case .touch:  return (0x18, 0x5)
            
        }
        
    }
    
}

extension MIDI.HUI.Parameter.AutoMode: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // Zone 0x18
        // Auto Mode (To the right of the channel strips)
        case .trim:   return ".trim"
        case .latch:  return ".latch"
        case .read:   return ".read"
        case .off:    return ".off"
        case .write:  return ".write"
        case .touch:  return ".touch"
        
        }

    }

}
