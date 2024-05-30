//
//  NSSceneProvider.swift
//  CodeEditV2
//
//  Created by Abe Malla on 4/10/24.
//

#if os(macOS)
import SwiftUI

final class NSSceneProvider: SceneProvider {
    @Environment(\.openWindow)
    var openWindow
    
    @inline(__always)
    func openScene(sceneId: SceneID) {
        openWindow(sceneID: sceneId)
    }
}
#endif
