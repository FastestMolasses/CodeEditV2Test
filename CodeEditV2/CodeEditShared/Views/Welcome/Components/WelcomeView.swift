//
//  WelcomeView.swift
//  CodeEditModules/WelcomeModule
//
//  Created by Ziyuan Zhao on 2022/3/18.
//

import SwiftUI
import Foundation
#if os(macOS)
import AppKit
#endif

struct WelcomeView: View {

    @Environment(\.colorScheme)
    var colorScheme
    
#if os(macOS)
    @Environment(\.controlActiveState)
    var controlActiveState
#endif
    
    //    @AppSettings(\.general.reopenBehavior)
    //    var reopenBehavior
    
    @State var showGitClone = false
    
    @State var showCheckoutBranchItem: URL?
    
    @State var isHovering: Bool = false
    
    @State var isHoveringCloseButton: Bool = false
    
#if os(iOS)
    @State private var showAboutWindow = false
#endif
    
    private let openDocument: (URL?, @escaping () -> Void) -> Void
    private let newDocument: () -> Void
    private let dismissWindow: () -> Void
    
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
        ZStack(alignment: .topLeading) {
            mainContent
            dismissButton
        }
        .onHover { isHovering in
            self.isHovering = isHovering
        }
        //        .sheet(isPresented: $showGitClone) {
        //            GitCloneView(
        //                openBranchView: { url in
        //                    showCheckoutBranchItem = url
        //                },
        //                openDocument: { url in
        //                    openDocument(url, dismissWindow)
        //                }
        //            )
        //        }
        //        .sheet(item: $showCheckoutBranchItem, content: { repoPath in
        //            GitCheckoutBranchView(
        //                repoLocalPath: repoPath,
        //                openDocument: { url in
        //                    openDocument(url, dismissWindow)
        //                }
        //            )
        //        })
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 32)
            ZStack {
                if colorScheme == .dark {
                    Rectangle()
                        .frame(width: 104, height: 104)
                        .foregroundColor(.accentColor)
                        .cornerRadius(24)
                        .blur(radius: 64)
                        .opacity(0.5)
                }
#if os(macOS)
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 128, height: 128)
#else
                Image("AppIcon")
                    .resizable()
                    .frame(width: 128, height: 128)
                    .onTapGesture {
                        self.showAboutWindow = true
                    }
#endif
            }
            Text(NSLocalizedString("CodeEdit", comment: ""))
                .font(.system(size: 36, weight: .bold))
            Text(
                String(
                    format: NSLocalizedString("Version %@%@ (%@)", comment: ""),
                    PlatformService.appVersion,
                    PlatformService.appVersionPostfix,
                    PlatformService.appBuild
                )
            )
            .textSelection(.enabled)
            .foregroundColor(.secondary)
            .font(.system(size: 13.5))
#if os(macOS)
            .onHover { hover in
                if hover {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
#elseif os(iOS)
//            .sheet(isPresented: $showAboutWindow) {
//                    AboutView()
//            }
            .sheet(isPresented: $showAboutWindow) {
                SettingsView(updater: SoftwareUpdater())
            }
#endif
            .onTapGesture {
                // TODO: DOESNT WORK
                PlatformService.copyInformation()
            }
            .help("Copy System Information to Clipboard")

            Spacer().frame(height: 40)
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // TODO: IOS OPTIONS:
                    // 1. CREATE LOCAL PROJECT
                    // 2. CLONE GIT REPOSITORY
                    // 3. OPEN FILE OR FOLDER
                    WelcomeActionView(
                        iconName: "plus.square",
                        title: NSLocalizedString("Create New File...", comment: ""),
                        action: {
                            newDocument()
                            dismissWindow()
                        }
                    )
                    WelcomeActionView(
                        iconName: "square.and.arrow.down.on.square",
                        title: NSLocalizedString("Clone Git Repository...", comment: ""),
                        action: {
                            showGitClone = true
                        }
                    )
                    WelcomeActionView(
                        iconName: "folder",
                        title: NSLocalizedString("Open File or Folder...", comment: ""),
                        action: {
                            openDocument(nil, dismissWindow)
                        }
                    )
                }
                .frame(maxWidth: .infinity)
            }
            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 56)
        .padding(.bottom, 16)
#if os(macOS)
        .frame(width: 460)
        .background(
            colorScheme == .dark
            ? Color(.black).opacity(0.2)
            : Color(.white).opacity(controlActiveState == .inactive ? 1.0 : 0.5)
        )
#else
        .background(
            colorScheme == .dark
            ? Color(.black).opacity(0.2)
            : Color(.white).opacity(0.5)
        )
#endif
        .background(EffectView(.underWindowBackground, blendingMode: .behindWindow))
    }
    
    private var dismissButton: some View {
#if os(macOS)
        Button(
            action: dismissWindow,
            label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(isHoveringCloseButton ? Color(.secondaryLabelColor) : Color(.tertiaryLabelColor))
            }
        )
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Close"))
        .onHover { hover in
            withAnimation(.linear(duration: 0.15)) {
                isHoveringCloseButton = hover
            }
        }
        .padding(10)
        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.25)))
#elseif os(iOS)
        return EmptyView()
#endif
    }
}
