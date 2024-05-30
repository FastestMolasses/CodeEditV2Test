//
//  SettingsForm.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/8/23.
//

import SwiftUI
//import SwiftUIIntrospect

struct SettingsForm<Content: View>: View {
    @Environment(\.colorScheme)
    private var colorScheme
#if os(macOS)
    @Environment(\.controlActiveState)
    private var activeState
#endif
    @EnvironmentObject var model: SettingsViewModel
    @ViewBuilder var content: Content

    var body: some View {
        Form {
            Section {
                EmptyView()
            } footer: {
                Rectangle()
                    .frame(height: 0)
                    .background(
                        GeometryReader {
                            Color.clear.preference(
                                key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named("scroll")).origin.y
                            )
                        }
                    )
                    .onPreferenceChange(ViewOffsetKey.self) {
                        if $0 <= -20.0 && !model.scrolledToTop {
                            withAnimation {
                                model.scrolledToTop = true
                            }
                        } else if $0 > -20.0 && model.scrolledToTop {
                            withAnimation {
                                model.scrolledToTop = false
                            }
                        }
                    }
            }
            content
        }
        // TODO: ADD BACK
//        .introspectScrollView { scrollView in
//            scrollView.scrollerInsets.top = 50
//        }
//        .introspect(.scrollView, on: .iOS(.v17), .macOS(.v13), scope: .ancestor) { scrollView in
//            scrollView.scrollerInsets.top = 50
//        }
        .formStyle(.grouped)
        .coordinateSpace(name: "scroll")
        .safeAreaInset(edge: .top, spacing: -50) {
            EffectView(.menu)
                .opacity(!model.scrolledToTop ? 1 : 0)
                .transaction { transaction in
                    transaction.animation = nil
                }
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        gradient: Gradient(
                            colors: [.black.opacity(colorScheme == .dark ? 1 : 0.17), .black.opacity(0)]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
#if os(macOS)
                    .frame(height: colorScheme == .dark || activeState == .inactive ? 1 : 2)
                    .padding(.bottom, colorScheme == .dark || activeState == .inactive ? -1 : -2)
#endif
                    .opacity(!model.scrolledToTop ? 1 : 0)
                    .transition(.opacity)
                }
                .ignoresSafeArea()
                .frame(height: 0)
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
