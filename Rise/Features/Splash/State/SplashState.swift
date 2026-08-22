//
//  SplashState.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI
import Observation

/// Presentation state and lifecycle coordinator for the Splash screen.
@Observable
@MainActor
public final class SplashState {
    public var isLogoVisible: Bool = false
    public var isTaglineVisible: Bool = false
    public var isMessageVisible: Bool = false
    public var isCardVisible: Bool = false
    public var isLoadingVisible: Bool = false
    public var isCompleted: Bool = false
    
    public init() {}
    
    /// Starts the orchestrated entrance animations and schedules the splash completion.
    public func start(reduceMotion: Bool, onFinish: @escaping () -> Void) {
        if reduceMotion {
            isLogoVisible = true
            isTaglineVisible = true
            isMessageVisible = true
            isCardVisible = true
            isLoadingVisible = true
            
            Task {
                try? await Task.sleep(for: .seconds(2.5))
                isCompleted = true
                onFinish()
            }
            return
        }
        
        // Sequenced entrance animations
        withAnimation(RiseAnimations.standardEase) {
            isLogoVisible = true
        }
        
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(RiseAnimations.interactiveSpring) {
                isTaglineVisible = true
            }
            
            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(RiseAnimations.standardEase) {
                isMessageVisible = true
            }
            
            try? await Task.sleep(for: .milliseconds(400))
            withAnimation(RiseAnimations.modalSpring) {
                isCardVisible = true
                isLoadingVisible = true
            }
            
            // Allow user to appreciate the artwork before transitioning
            try? await Task.sleep(for: .seconds(2.2))
            withAnimation(RiseAnimations.standardEase) {
                isCompleted = true
            }
            try? await Task.sleep(for: .milliseconds(300))
            onFinish()
        }
    }
}
