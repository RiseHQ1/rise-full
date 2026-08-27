//
//  RiseRadius.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Standardized corner radius tokens for Rise surfaces, cards, and interactive controls.
public enum RiseRadius {
    /// 8 pt - Small tags, micro indicators, badge corners
    public static let small: CGFloat = 8

    /// 12 pt - Standard buttons, text input fields, thumbs
    public static let medium: CGFloat = 12

    /// 14 pt - Compact wells, text editors, preference inset rows
    public static let control: CGFloat = 14

    /// 16 pt - Standard content cards, dialogs, alerts
    public static let large: CGFloat = 16

    /// 18 pt - Rich glass content cards (default `riseRichGlass`)
    public static let card: CGFloat = 18

    /// 20 pt - Featured / mid-hero cards
    public static let cardLarge: CGFloat = 20

    /// 24 pt - Large cards, featured hero containers, bottom sheets
    public static let extraLarge: CGFloat = 24

    /// 9999 pt - Capsule pills, progress tracks, and selectable tags
    public static let pill: CGFloat = 9999

    /// 9999 pt - Circular icon buttons and profile avatars
    public static let full: CGFloat = 9999

    // MARK: - Compatibility Aliases

    public static var sm: CGFloat {
        small
    }

    public static var md: CGFloat {
        medium
    }

    public static var lg: CGFloat {
        large
    }

    public static var xl: CGFloat {
        extraLarge
    }

    public static var xxl: CGFloat {
        32
    }
}
