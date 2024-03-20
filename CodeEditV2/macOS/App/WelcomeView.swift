//
//  WelcomeView.swift
//  CodeEditV2
//
//  Created by Abe Malla on 3/19/24.
//

import SwiftUI

struct WelcomeView: View {
    private var recentProjects: [RecentProject] = ProjectManager.shared.getRecentProjects()
    
    var body: some View {
        NavigationView {
            List(recentProjects) { project in
                Text(project.name)
            }
            .navigationTitle("Welcome to YourCodeEditor!")
            .frame(minWidth: 300, minHeight: 200)
        }
    }
}
