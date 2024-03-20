//
//  CodeEdit.swift
//  CodeEditV2
//
//  Created by Abe Malla on 3/19/24.
//

import SwiftUI

#if os(macOS)
@main
struct CodeEdit: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
#endif
