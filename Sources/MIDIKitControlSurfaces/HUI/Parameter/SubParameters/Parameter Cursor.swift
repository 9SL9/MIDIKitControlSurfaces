//
//  Parameter Cursor.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Cursor Movement / Mode / Scrub / Shuttle
    public enum Cursor: Equatable, Hashable {
        
        case up
        case left
        case right
        case down
        case mode    // has LED; button in center of cursor direction keys
        
        case scrub   // has LED; to the right of the jogwheel
        case shuttle // has LED; to the right of the jogwheel
        
    }
    
}

extension MIDI.HUI.Parameter.Cursor: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x0D
        // Cursor Movement / Mode / Scrub / Shuttle
        case .down:     return (0x0D, 0x0)
        case .left:     return (0x0D, 0x1)
        case .mode:     return (0x0D, 0x2)
        case .right:    return (0x0D, 0x3)
        case .up:       return (0x0D, 0x4)
        case .scrub:    return (0x0D, 0x5)
        case .shuttle:  return (0x0D, 0x6)
            
        }
        
    }
    
}

extension MIDI.HUI.Parameter.Cursor: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // Zone 0x0D
        // Cursor Movement / Mode / Scrub / Shuttle
        case .down:     return ".down"
        case .left:     return ".left"
        case .mode:     return ".mode"
        case .right:    return ".right"
        case .up:       return ".up"
        case .scrub:    return ".scrub"
        case .shuttle:  return ".shuttle"
        
        }

    }

}
