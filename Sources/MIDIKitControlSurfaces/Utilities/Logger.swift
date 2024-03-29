//
//  Logger.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import os.log

internal enum Logger {
    
    /// Prints a message to the console log. (`os_log`).
    /// Only outputs to log in a `DEBUG` build.
    @inline(__always)
    internal static func debug(_ message: String) {
        
        #if DEBUG
        os_log("%{public}@",
               log: OSLog.default,
               type: .debug,
               "HUI: " + message)
        #endif
        
    }
    
}
