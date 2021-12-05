//
//  ContentView.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import MIDIKitControlSurfaces
import SwiftUI

struct ContentView: View {
    private let midiManager = MIDI.IO.Manager(
        clientName: "HUISurface",
        model: "HUISurface",
        manufacturer: "Orchetect",
        notificationHandler: nil
    )

    @ObservedObject private var huiSurface: MIDI.HUI.Surface
    
    static let kHUIInputName = "MIDIKit HUI Input"
    static let kHUIOutputName = "MIDIKit HUI Output"
    
    init() {
        // set up HUI Surface object

        huiSurface = MIDI.HUI.Surface()

        huiSurface.huiEventHandler = { event in
            // Logger.debug(event)
        }

        huiSurface.midiOutHandler = { [weak midiManager] midiEvents in
            guard let output = midiManager?
                    .managedOutputs[Self.kHUIOutputName]
            else {
                Logger.debug("MIDI output missing.")
                return
            }
            
            do {
                try output.send(events: midiEvents)
            } catch {
                Logger.debug(error.localizedDescription)
            }
        }

        // set up MIDI ports

        do {
            try midiManager.start()

            try midiManager.addInput(
                name: Self.kHUIInputName,
                tag: Self.kHUIInputName,
                uniqueID: .userDefaultsManaged(key: Self.kHUIInputName),
                receiveHandler: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false)
                { [weak huiSurface] midiEvents in
                    // since handler callbacks from MIDI are on a CoreMIDI thread, parse the MIDI on the main thread because SwiftUI state in this app will be updated as a result
                    DispatchQueue.main.async {
                        huiSurface?.midiIn(events: midiEvents)
                    }
                }
            )

            try midiManager.addOutput(
                name: Self.kHUIOutputName,
                tag: Self.kHUIOutputName,
                uniqueID: .userDefaultsManaged(key: Self.kHUIOutputName)
            )
        } catch {
            // Logger.error("Error setting up MIDI.")
        }
    }
    
    var body: some View {
        HUISurfaceView()
            .frame(maxWidth: .infinity)
            .environmentObject(huiSurface)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
