//
//  AccoundsSettingsAccountRow.swift
//  CodeEdit
//
//  Created by Austin Condiff on 4/5/23.
//

import SwiftUI

struct AccountsSettingsProviderRow: View {
    var name: String
    var iconName: String
    var action: () -> Void

    @State private var hovering = false
    @State private var pressing = false

    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(6)
                .frame(width: 28, height: 28)
            Text(name)
            Spacer()
            if hovering {
                Image(systemName: "plus")
#if os(macOS)
                    .foregroundColor(Color(.tertiaryLabelColor))
#elseif os(iOS)
                    .foregroundColor(Color(.tertiaryLabel))
#endif
                    .padding(.horizontal, 5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
#if os(macOS)
        .background(pressing ? Color(nsColor: .quaternaryLabelColor) : Color(nsColor: .clear))
#elseif os(iOS)
        .background(pressing ? Color(.quaternaryLabel) : Color(.clear))
#endif
        .overlay(Color(.black).opacity(0.0001))
        .onHover { hover in
            hovering = hover
        }
        .pressAction {
            pressing = true
        } onRelease: {
            pressing = false
            action()
        }
    }
}
