//
//  AboutScene.swift
//  CodeEditV2
//
//  Created by Abe Malla on 4/26/24.
//

#if os(macOS)
import SwiftUI

struct AboutScene: Scene {
    var body: some Scene {
        Window("", id: SceneID.about.rawValue) {
            AboutView()
        }
        .defaultSize(width: 530, height: 220)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
#endif
