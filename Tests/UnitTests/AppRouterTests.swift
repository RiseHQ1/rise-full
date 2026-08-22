//
//  AppRouterTests.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Testing
import SwiftUI
@testable import Rise

@Suite("AppRouter Tests")
struct AppRouterTests {
    @Test("AppRouter initializes with empty paths")
    @MainActor
    func testInitialization() {
        let router = AppRouter()
        #expect(router.homePath.isEmpty)
        #expect(router.discoverPath.isEmpty)
        #expect(router.journalPath.isEmpty)
        #expect(router.progressPath.isEmpty)
        #expect(router.profilePath.isEmpty)
    }
    
    @Test("AppRouter popToRoot resets path")
    @MainActor
    func testPopToRoot() {
        let router = AppRouter()
        router.homePath.append(AppRoute.settings)
        #expect(!router.homePath.isEmpty)
        
        router.popToRoot(for: .home)
        #expect(router.homePath.isEmpty)
    }
}
