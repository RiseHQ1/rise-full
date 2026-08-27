//
//  RiseAccessibility.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI

/// Shared accessibility identifiers for UI tests and Accessibility Inspector.
public enum RiseAccessibilityID {
    public static let tabBar = "rise.tabBar"
    public static let featureBack = "rise.feature.back"
    public static let searchField = "rise.search.field"
    public static let primaryCTA = "rise.cta.primary"
    public static let goldCTA = "rise.cta.gold"
    public static let breathePlay = "rise.breathe.play"
    public static let breathePhase = "rise.breathe.phase"
    public static let breatheTimer = "rise.breathe.timer"

    public static func tab(_ tab: AppTab) -> String {
        "rise.tab.\(tab.rawValue)"
    }
}

public extension View {
    /// Minimum 44×44 pt hit target without changing visual size.
    func riseMinimumHitTarget(
        _ size: CGFloat = RiseIconButtonMetrics.minimumHitTarget
    ) -> some View {
        frame(minWidth: size, minHeight: size)
            .contentShape(Rectangle())
    }
}
