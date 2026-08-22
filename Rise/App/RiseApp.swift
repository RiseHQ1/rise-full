//
//  RiseApp.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

@main
struct RiseApp: App {
    @State private var appState = AppState()
    @State private var appRouter = AppRouter()
    private let container = DependencyContainer.live()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(appRouter)
                .environment(\.dependencyContainer, container)
        }
    }
}
