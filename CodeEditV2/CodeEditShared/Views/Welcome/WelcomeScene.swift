//
//  WelcomeWindow.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import SwiftUI

struct WelcomeScene: Scene {
    
    // TODO: RE-ENABLE FOR WHEN SETTINGS IMPLEMENTED FOR IOS
    //    @ObservedObject var settings = Settings.shared

    var body: some Scene {
#if os(macOS)
        Window("Welcome To CodeEdit", id: SceneID.welcome.rawValue) {
            ContentView()
                .frame(width: 740, height: 432)
                .task {
                    if let window = NSApp.findWindow(.welcome) {
                        window.standardWindowButton(.closeButton)?.isHidden = true
                        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                        window.standardWindowButton(.zoomButton)?.isHidden = true
                        window.isMovableByWindowBackground = true
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
#elseif os(iOS)
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
#endif
    }

    struct ContentView: View {
        @Service private var documentService: DocumentService

        @Environment(\.dismiss)
        var dismiss
        @Environment(\.openWindow)
        var openWindow
        
        var body: some View {
            WelcomeWindowView { url, opened in
                if let url {
                    documentService.openDocument(withContentsOf: url, display: true) { doc, _, _ in
                        if doc != nil {
                            opened()
                        }
                    }
                } else {
                    dismiss()
                    documentService.openDocument(
                        onCompletion: { _, _ in opened() },
                        onCancel: { openWindow(id: SceneID.welcome.rawValue) }
                    )
                }
            } newDocument: {
                documentService.newDocument()
            } dismissWindow: {
                dismiss()
            }
        }
    }
}
