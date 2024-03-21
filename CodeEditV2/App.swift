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
        WelcomeScene()
    }
}

private extension CodeEdit {
    func setupServiceContainer() {
        ServiceContainer.register(
            type: PasteboardService.self,
            PasteboardService()
        )
    }
}
