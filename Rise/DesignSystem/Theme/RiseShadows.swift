//
//  RiseShadows.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Semantic shadow and ambient glow definitions for Rise.
public struct RiseShadow {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(color: Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

public enum RiseShadows {
    // MARK: - Elevations
    /// Subtle drop shadow for low-elevation surface separation.
    public static let elevationLow = RiseShadow(
        color: Color.black.opacity(0.25),
        radius: 6,
        x: 0,
        y: 3
    )
    
    /// Standard card elevation for content layers.
    public static let elevationMedium = RiseShadow(
        color: Color.black.opacity(0.35),
        radius: 12,
        x: 0,
        y: 6
    )
    
    /// Elevated shadow for floating action buttons, sheets, and popups.
    public static let elevationHigh = RiseShadow(
        color: Color.black.opacity(0.45),
        radius: 24,
        x: 0,
        y: 12
    )
    
    // MARK: - Ambient Glows
    /// Soft ambient violet glow for highlighted interactive elements and primary buttons.
    public static let accentGlow = RiseShadow(
        color: RiseColors.accentPrimary.opacity(0.30),
        radius: 16,
        x: 0,
        y: 4
    )
    
    /// Soft ambient golden glow for streak badges and achievement milestones.
    public static let warmGlow = RiseShadow(
        color: RiseColors.accentSecondary.opacity(0.25),
        radius: 16,
        x: 0,
        y: 4
    )
    
    // MARK: - Compatibility Aliases
    public static var subtle: RiseShadow { elevationLow }
    public static var cardElevated: RiseShadow { elevationMedium }
    public static var glow: RiseShadow { accentGlow }
    public static var goldGlow: RiseShadow { warmGlow }
}

public extension View {
    /// Applies a standardized RiseShadow to the view.
    func riseShadow(_ shadow: RiseShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
