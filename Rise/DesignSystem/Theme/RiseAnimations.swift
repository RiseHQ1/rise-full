//
//  RiseAnimations.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Standardized animation curves and durations for Rise.
///
/// Designed to feel calm, smooth, intentional, and slightly springy while respecting user motion preferences.
public enum RiseAnimations {
    // MARK: - Standard Curves

    /// Smooth, responsive spring for interactive taps, toggles, and button presses.
    public static let interactiveSpring = Animation.spring(response: 0.32, dampingFraction: 0.78)

    /// Soft, calm spring for modal transitions, card expansions, and sheet reveals.
    public static let modalSpring = Animation.spring(response: 0.45, dampingFraction: 0.85)

    /// Gentle ease-in-out for subtle opacity fades and background transitions.
    public static let standardEase = Animation.easeInOut(duration: 0.25)

    /// Slow, meditative breathing curve for pacing mindful exercises.
    public static let gentleBreath = Animation.easeInOut(duration: 3.5)

    // MARK: - Signature Curves

    /// Soft first-appearance spring — slightly slower than interactive for entrance choreography.
    public static let riseIn = Animation.spring(response: 0.52, dampingFraction: 0.86)

    /// Snappy settle for chips, phase changes, and selection highlights.
    public static let riseSettle = Animation.spring(response: 0.38, dampingFraction: 0.72)

    /// Short gold success pulse (scale + glow moments).
    public static let goldPulse = Animation.spring(response: 0.42, dampingFraction: 0.62)

    // MARK: - Helper Functions

    /// Returns the animation or nil if the user has enabled Reduce Motion.
    public static func preferred(_ animation: Animation, reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : animation
    }

    /// Delayed signature entrance; nil when Reduce Motion is on.
    public static func preferredRiseIn(delay: Double, reduceMotion: Bool) -> Animation? {
        preferred(riseIn.delay(delay), reduceMotion: reduceMotion)
    }
}
