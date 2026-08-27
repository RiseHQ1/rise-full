//
//  AppRouterTests.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

@testable import Rise
import SwiftUI
import Testing

@Suite("AppRouter Tests")
struct AppRouterTests {
    @Test("AppRouter initializes with empty paths")
    @MainActor
    func initialization() {
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
