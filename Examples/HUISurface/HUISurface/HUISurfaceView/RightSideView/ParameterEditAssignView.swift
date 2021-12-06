//
//  RightSideView.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    
    /// "DSP EDIT/ASSIGN" Section
    func ParameterEditAssignView() -> some View {
        
        HStack(alignment: .top, spacing: nil) {
            Group {
                VStack {
                    HUIStateButton("ASSIGN",
                                   .parameterEdit(.assign),
                                   .green)
                    HUIStateButton("COMPARE",
                                   .parameterEdit(.compare),
                                   .green,
                                   fontSize: 8.5)
                    HUIStateButton("BYPASS",
                                   .parameterEdit(.bypass),
                                   .green)
                }
                
                HStack {
                    HUISectionDivider(.vertical)
                    
                    // Param 1
                    VStack {
                        HUIStateButton("SELECT",
                                       .parameterEdit(.param1Select),
                                       .green)
                        RotaryKnob(size: 40) // .parameterEdit(.param1VPot)
                    }
                    .frame(width: 75)
                    
                    HUISectionDivider(.vertical)
                    
                    // Param 2
                    VStack {
                        HUIStateButton("SELECT",
                                       .parameterEdit(.param2Select),
                                       .green)
                        RotaryKnob(size: 40) // .parameterEdit(.param2VPot)
                    }
                    .frame(width: 75)
                    
                    HUISectionDivider(.vertical)
                    
                    // Param 3
                    VStack {
                        HUIStateButton("SELECT",
                                       .parameterEdit(.param3Select),
                                       .green)
                        RotaryKnob(size: 40) // .parameterEdit(.param3VPot)
                    }
                    .frame(width: 75)
                    
                    HUISectionDivider(.vertical)
                    
                    // Param 4
                    VStack {
                        HUIStateButton("SELECT",
                                       .parameterEdit(.param4Select),
                                       .green)
                        RotaryKnob(size: 40) // .parameterEdit(.param4VPot)
                    }
                    .frame(width: 75)
                    
                    HUISectionDivider(.vertical)
                }
                
                VStack {
                    HUIStateButton("INSERT ○\nPARAM ●",
                                   .parameterEdit(.insertOrParam),
                                   .green,
                                   width: 60)
                    RotaryKnob(size: 20)
                    Text("SCROLL")
                        .font(.system(size: 9))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        
    }
    
}
