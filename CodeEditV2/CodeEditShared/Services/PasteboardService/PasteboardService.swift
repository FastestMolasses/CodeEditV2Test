//
//  PasteboardService.swift
//  CodeEditV2
//
//  Created by Abe Malla on 3/20/24.
//

protocol PasteboardProvider {
    static func string() -> String?
    static func setString(_ string: String)
}

final class PasteboardService {
    private let pasteboard: PasteboardProvider.Type

    init() {
        // Initialize a provider based on platform
        #if os(macOS)
        self.pasteboard = NSPasteboardProvider.self
        #elseif os(iOS)
        self.pasteboard = UIPasteboardProvider.self
        #endif
    }

    func copy(_ string: String) {
        self.pasteboard.setString(string)
    }

    func paste() -> String? {
        self.pasteboard.string()
    }
}
