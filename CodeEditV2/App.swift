//
//  App.swift
//  CodeEditV2
//
//  Created by Abe Malla on 3/20/24.
//

import SwiftUI

@main
struct CodeEdit: App {
    init() {
        setupServiceContainer()
    }

    var body: some Scene {
        Group {
            WelcomeScene()

#if os(macOS)
            // On macOS, the "About" view is displayed as a window.
            // On iOS, it is presented as a sheet.
            AboutScene()

            SettingsScene()
#endif
        }
    }
}

private extension CodeEdit {
    func setupServiceContainer() {
        ServiceContainer.register(
            PasteboardService()
        )
        ServiceContainer.register(
            DocumentService()
        )
        ServiceContainer.register(
            FileService()
        )
        ServiceContainer.register(
            SceneService()
        )
    }
}
