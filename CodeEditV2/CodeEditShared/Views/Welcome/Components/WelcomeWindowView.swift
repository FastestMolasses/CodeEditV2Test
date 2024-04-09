//
//  WelcomeWindowView.swift
//  CodeEditModules/WelcomeModule
//
//  Created by Ziyuan Zhao on 2022/3/18.
//

import SwiftUI

struct WelcomeWindowView: View {
    private let openDocument: (URL?, @escaping () -> Void) -> Void
    private let newDocument: () -> Void
    private let dismissWindow: () -> Void
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
#endif
    
    init(
        openDocument: @escaping (URL?, @escaping () -> Void) -> Void,
        newDocument: @escaping () -> Void,
        dismissWindow: @escaping () -> Void
    ) {
        self.openDocument = openDocument
        self.newDocument = newDocument
        self.dismissWindow = dismissWindow
    }

    var body: some View {
#if os(macOS)
        content
            .horizontalStack()
#elseif os(iOS)
        // If we are on a portrait iPhone, stack views vertically
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            content
                .verticalStack()
        } else {
            content
                .horizontalStack()
        }
#endif

        //        HStack(spacing: 0) {
        //            WelcomeView(
        //                openDocument: openDocument,
        //                newDocument: newDocument,
        //                dismissWindow: dismissWindow
        //            )
        //            RecentProjectsListView(openDocument: openDocument, dismissWindow: dismissWindow)
        //                .frame(width: 280)
        //        }
        //        .edgesIgnoringSafeArea(.top)
        // TODO: ENABLE
        //        .onDrop(of: [.fileURL], isTargeted: .constant(true)) { providers in
        //            NSApp.activate(ignoringOtherApps: true)
        //            providers.forEach {
        //                _ = $0.loadDataRepresentation(for: .fileURL) { data, _ in
        //                    if let data, let url = URL(dataRepresentation: data, relativeTo: nil) {
        //                        Task {
        //                            try? await CodeEditDocumentController
        //                                .shared
        //                                .openDocument(withContentsOf: url, display: true)
        //                        }
        //                    }
        //                }
        //            }
        //            dismissWindow()
        //            return true
        //        }
    }
    
    var content: some View {
        Group {
            WelcomeView(
                openDocument: openDocument,
                newDocument: newDocument,
                dismissWindow: dismissWindow
            )
            RecentProjectsListView(openDocument: openDocument, dismissWindow: dismissWindow)
                .frame(minWidth: 280)
        }
    }
}

fileprivate extension View {
    func horizontalStack() -> some View {
        HStack(spacing: 0) {
            self
        }
        .edgesIgnoringSafeArea(.vertical)
    }
    
    func verticalStack() -> some View {
        VStack {
            self
        }
        .edgesIgnoringSafeArea(.top)
    }
}
