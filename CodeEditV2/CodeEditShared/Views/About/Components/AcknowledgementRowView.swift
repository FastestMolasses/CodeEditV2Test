//
//  AcknowledgementRowView.swift
//  CodeEditV2
//
//  Created by Abe Malla on 4/26/24.
//

import SwiftUI

struct AcknowledgementRowView: View {
    @Environment(\.openURL)
    private var openURL

    let acknowledgement: AcknowledgementDependency

    var body: some View {
        HStack {
            Text(acknowledgement.name)
                .font(.body)

            Spacer()

            Button {
                openURL(acknowledgement.repositoryURL)
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                // TODO:
//                    .foregroundColor(Color(nsColor: .tertiaryLabelColor))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
    }
}
