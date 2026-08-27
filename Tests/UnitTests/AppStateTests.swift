//
//  AppStateTests.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

@testable import Rise
import Testing

@Suite("AppState Tests")
struct AppStateTests {
    @Test("AppState initializes with default values")
    @MainActor
    func initialization() {
        let appState = AppState()
        #expect(appState.isSplashPresented == true)
        #expect(appState.selectedTab == .home)
        #expect(appState.isAuthenticated == false)
        #expect(appState.isOffline == false)
    }

    @Test("AppState updates selected tab")
    @MainActor
    func tabSwitching() {
        let appState = AppState()
        appState.selectedTab = .journal
        #expect(appState.selectedTab == .journal)
    }
}
