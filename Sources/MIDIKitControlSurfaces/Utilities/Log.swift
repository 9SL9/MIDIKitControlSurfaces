//
//  Log.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import os.log

internal enum Log {
    
    /// Prints a message to the console log. (`os_log`). Only outputs to log in a `DEBUG` build.
    internal static func debug(_ message: String) {
        
        #if DEBUG
        os_log("%{public}@",
               log: OSLog.default,
               type: .debug,
               message)
        #endif
        
    }
    
}
