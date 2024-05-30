//
//  SceneService.swift
//  CodeEditV2
//
//  Created by Abe Malla on 4/9/24.
//

import Foundation

protocol SceneProvider {
    func openScene(sceneId: SceneID)
//    static func openScene()
//    static func closeScene()
}

/// A service for managing scenes across the application
final class SceneService {
    private let sceneProvider: SceneProvider

    init() {
        // Initialize a provider based on platform
#if os(macOS)
        sceneProvider = NSSceneProvider()
#elseif os(iOS)
        sceneProvider = UISceneProvider()
#endif
    }

    func openScene() {
//        self.sceneProvider.openScene()
    }

    func closeScene() {
//        self.sceneProvider.closeScene()
    }
}
