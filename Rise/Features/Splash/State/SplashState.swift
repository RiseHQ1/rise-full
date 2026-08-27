//
//  SplashState.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Observation
import SwiftUI

/// Presentation state, live session bootstrap, and lifecycle coordinator for the Splash screen.
@Observable
@MainActor
public final class SplashState {
    public var isLogoVisible: Bool = false
    public var isTaglineVisible: Bool = false
    public var isMessageVisible: Bool = false
    public var isCardVisible: Bool = false
    public var isLoadingVisible: Bool = false
    public var isCompleted: Bool = false
    public var isSessionRestored: Bool = false

    public init() {}

    /// Starts the orchestrated entrance animations, validates live session with Rise API, and transitions to root.
    public func start(reduceMotion: Bool, onFinish: @escaping () -> Void) {
        // Asynchronously bootstrap session with live Rise Server
        Task {
            await bootstrapSession()
        }

        if reduceMotion {
            isLogoVisible = true
            isTaglineVisible = true
            isMessageVisible = true
            isCardVisible = true
            isLoadingVisible = true

            Task {
                try? await Task.sleep(for: .seconds(2.0))
                isCompleted = true
                onFinish()
            }
            return
        }

        // Sequenced entrance animations — soft Rise signature curve.
        withAnimation(RiseAnimations.riseIn) {
            isLogoVisible = true
        }

        Task {
            try? await Task.sleep(for: .milliseconds(250))
            withAnimation(RiseAnimations.riseIn) {
                isTaglineVisible = true
            }

            try? await Task.sleep(for: .milliseconds(250))
            withAnimation(RiseAnimations.riseIn) {
                isMessageVisible = true
            }

            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(RiseAnimations.modalSpring) {
                isCardVisible = true
                isLoadingVisible = true
            }

            // Allow user to appreciate the artwork before transitioning
            try? await Task.sleep(for: .seconds(1.8))
            withAnimation(RiseAnimations.standardEase) {
                isCompleted = true
            }
            try? await Task.sleep(for: .milliseconds(250))
            onFinish()
        }
    }

    /// Validates existing Keychain token with live backend or silently falls back.
    private func bootstrapSession() async {
        guard RiseAPIClient.shared.isAuthenticated else {
            return
        }

        do {
            struct MeResponse: Decodable {
                let user: UserDTO
            }
            let response: MeResponse = try await RiseAPIClient.shared.request(endpoint: "auth/me")
            isSessionRestored = true
            RiseLogger.info("Session successfully restored for user: \(response.user.name) (\(response.user.id))")
        } catch {
            RiseLogger.warning("Session token validation failed or offline: \(error.localizedDescription)")
        }
    }
}
