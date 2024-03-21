//
//  NSPasteboardProvider.swift
//  CodeEditV2
//
//  Created by Abe Malla on 3/20/24.
//

#if os(macOS)
import AppKit

class NSPasteboardProvider: PasteboardProvider {
    @inline(__always)
    func string(forType: String) -> String? {
        return NSPasteboard.general.string(forType: .string)
    }

    @inline(__always)
    func setString(_ string: String, forType: String) {
        NSPasteboard.general.setString(string, forType: .string)
    }
}
#endif
