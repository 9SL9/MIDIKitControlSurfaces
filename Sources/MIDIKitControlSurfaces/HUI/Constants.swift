//
//  Constants.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

// MARK: - HUI System Constants

extension MIDI.HUI {
    
    public enum kMIDI {
        
        // MARK: System messages
        
        // Status 0x9 is normally channel voice note-on, but HUI hijacks it.
        // [0x90, 0x00, 0x00]
        public static let kPingFromHostMessage: MIDI.Event =
            .noteOn(0, velocity: .midi1(0), channel: 0, midi1ZeroVelocityAsNoteOff: false)
        
        // Status 0x9 is normally channel voice note-on, but HUI hijacks it.
        // [0x90, 0x00, 0x7F]
        public static let kPingReplyToHostMessage: MIDI.Event =
            .noteOn(0, velocity: .midi1(0x7F), channel: 0)
        
        public static let kSystemResetMessage: MIDI.Event =
            .systemReset() // [0xFF]
        
        // [0xF0, 0x00, 0x00, 0x66, 0x05, 0x00]
        public enum kSysEx {
            public static let kManufacturer: MIDI.Event.SysExManufacturer =
                .threeByte(byte2: 0x00, byte3: 0x66) // Mackie
            public static let kSubID1: MIDI.Byte = 0x05 // product ID?
            public static let kSubID2: MIDI.Byte = 0x00
        }
        
        public enum kDisplayType {
            /// 4-character channel name displays, and Select-Assign displays
            public static let smallByte: MIDI.Byte = 0x10
            /// Main time display (can be switched between modes, such as timecode, bars/beats, etc.)
            public static let timeDisplayByte: MIDI.Byte = 0x11
            /// Main 40x2 character display
            public static let largeByte: MIDI.Byte = 0x12
        }
        
        // Status 0xA is normally MIDI poly aftertouch, but HUI hijacks it.
        public static let kLevelMetersStatus: MIDI.Byte = 0xA0
        
        // MARK: Control events
        
        // Status 0xB is normally channel voice control change, but HUI hijacks it.
        // HUI only ever uses first channel, so the status byte will always be exactly 0xB0.
        // HUI also uses running status for back-to-back 0xB status messages.
        public static let kControlStatus: MIDI.Byte = 0xB0
        
        public enum kControlDataByte1 {
            public static let zoneSelectByte: MIDI.Byte = 0x0C
            public static let portOnOffByte: MIDI.Byte = 0x2C
        }
        
        public enum kChannelStripElement: MIDI.UInt4, Equatable, Hashable {
            
            case fader  = 0x0
            case select = 0x1
            case mute   = 0x2
            case solo   = 0x3
            case auto   = 0x4
            case vSel   = 0x5
            case insert = 0x6
            case rec    = 0x7
            
        }
        
        public static let kSysExStartByte: MIDI.Byte = 0xF0
        public static let kSysExEndByte: MIDI.Byte = 0xF7
        
    }
    
}

// MARK: - HUI Character Tables

extension MIDI.HUI {
    
    /// HUI Character & String Tables
    ///
    /// There are more values to this table - need to discover what they are.
    /// (Pro Tools uses index values upwards of 48, maybe beyond)
    enum kCharTables {
        
        static let timeDisplay = [
            "0",  "1",  "2",  "3",    // 0x00 ...
            "4",  "5",  "6",  "7",    //
            "8",  "9",  "A",  "B",    //
            "C",  "D",  "E",  "F",    //      ... 0x0F
            "0.", "1.", "2.", "3.",   // 0x10 ...
            "4.", "5.", "6.", "7.",   //
            "8.", "9.", "A.", "B.",   //
            "C.", "D.", "E.", "F.",   //      ... 0x1F
            " ",                      // 0x20 - this is a guess; I think it's an empty space, or an empty string
            "?",  "?",  "?",  "?",    // 0x21 ...
            "?",  "?",  "?",  "?",    //
            "?",  "?",  "?",  "?",    //
            "?",  "?",  "?",          // 0x2F - placeholders, not sure about these; put in question marks for now
            " ."                      // 0x30 - this is a guess; I think it's an empty space with a period
        ]
        
        static let largeDisplay = [
            "",   "",   "",   "",     // 0x00 ...
            "",   "",   "",   "",     //
            "",   "",   "",   "",     //
            "",   "",   "",   "",     //      ... 0x0F
            "11",   "12", "13", "14", // 0x10 ...
            "full", "r4", "r3", "r2", //
            "r1",    "♪", "°C", "°F", //
            "▼",     "▶︎",  "◀︎",  "▲", //      ... 0x1F
            " ",  "!",  "\"", "#",    // 0x20 ...
            "$",  "%",  "&",  "'",    //
            "(",  ")",  "*",  "+",    //
            ",",  "-",  ".",  "/",    //      ... 0x2F
            "0",  "1",  "2",  "3",    // 0x30 ...
            "4",  "5",  "6",  "7",    //
            "8",  "9",  ":",  ";",    //
            "<",  "=",  ">",  "?",    //      ... 0x3F
            "@",  "A",  "B",  "C",    // 0x40 ...
            "D",  "E",  "F",  "G",    //
            "H",  "I",  "J",  "K",    //
            "L",  "M",  "N",  "O",    //      ... 0x4F
            "P",  "Q",  "R",  "S",    // 0x50 ...
            "T",  "U",  "V",  "W",    //
            "X",  "Y",  "Z",  "[",    //
            "\\", "]",  "^",  "_",    //      ... 0x5F
            "`",  "a",  "b",  "c",    // 0x60 ...
            "d",  "e",  "f",  "g",    //
            "h",  "i",  "j",  "k",    //
            "l",  "m",  "n",  "o",    //      ... 0x6F
            "p",  "q",  "r",  "s",    // 0x70 ...
            "t",  "u",  "v",  "w",    //
            "x",  "y",  "z",  "{",    //
            "|",  "}",  "→",  "←"     //      ... 0x7F
        ]
        
        static let smallDisplay = [
            "ì", "↑", "→", "↓", "←", "¿", "à", "Ø", "ø", "ò", "ù", "Ň", "Ç", "ê", "É", "é", // 0x00 ... 0x0F
            "è", "Æ", "æ", "Å", "å", "Ä", "ä", "Ö", "ö", "Ü", "ü","°C","°F", "ß", "£", "¥", // 0x10 ... 0x1F
            " ", "!", "\"","#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", // 0x20 ... 0x2F
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", // 0x30 ... 0x3F
            "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", // 0x40 ... 0x4F
            "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\","]", "^", "_", // 0x50 ... 0x5F
            "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", // 0x60 ... 0x6F
            "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~", "░"  // 0x70 ... 0x7F
        ]
        
        static let vPotLEDMatrix = [
            "           ", "*          ", " *         ", "  *        ", // 0x00 ...
            "   *       ", "    *      ", "     *     ", "      *    ",
            "       *   ", "        *  ", "         * ", "          *",
            "           ", "           ", "           ", "           ",
            "           ", "******     ", " *****     ", "  ****     ",
            "   ***     ", "    **     ", "     *     ", "     **    ",
            "     ***   ", "     ****  ", "     ***** ", "     ******", //      ... 0x2B
            
            "           ", "           ", "           ", "           ", // (these might not be used)
            
            "           ", "*          ", "**         ", "***        ", // 0x30 ...
            "****       ", "*****      ", "******     ", "*******    ",
            "********   ", "*********  ", "********** ", "***********", //      ... 0x3B
            
            "           ", "           ", "           ", "           ", // (these might not be used)
            
            "           ", "     *     ", "    ***    ", "   *****   ", // 0x40 ...
            "  *******  ", " ********* ", "***********", "***********",
            "***********", "***********", "***********", "***********"  //      ... 0x4B
        ]
        
        // There is also a small LED under the encoder that can be turned on by adding 40 to v.
        
    }
    
}

// MARK: - HUI Zones and Ports tables

extension MIDI.HUI {
    
    public typealias Zone = MIDI.Byte
    public typealias Port = MIDI.UInt4
    
    public typealias ZoneAndPortPair = (zone: Zone, port: Port)
    
}
