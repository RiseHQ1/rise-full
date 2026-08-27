//
//  RiseTypography.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Centralized typography system for Rise with full Dynamic Type support and custom font readiness.
///
/// Prefer these tokens over `.font(.system(size:…))` so text scales with Accessibility sizes.
public enum RiseTypography {
    // MARK: - Custom Font Configuration Hook

    /// Future custom display font family name (e.g. "PlusJakartaSans", "Outfit", or "PlayfairDisplay").
    /// When set to `nil`, standard Apple system fonts with Dynamic Type are utilized.
    public static var customDisplayFontName: String?

    // MARK: - Display & Hero

    /// Large confident heading for splash, hero intros, and milestone celebrations (~34 bold).
    public static var display: Font {
        if let name = customDisplayFontName {
            return Font.custom(name, size: 34, relativeTo: .largeTitle).weight(.bold)
        }
        return Font.system(.largeTitle, design: .rounded, weight: .bold)
    }

    /// Soft display weight used by Home greeting lines (~34 semibold).
    public static var displaySoft: Font {
        if let name = customDisplayFontName {
            return Font.custom(name, size: 34, relativeTo: .largeTitle).weight(.semibold)
        }
        return Font.system(.largeTitle, design: .rounded, weight: .semibold)
    }

    /// Hero editorial heading for daily themes and feature banners (~28 bold).
    public static var hero: Font {
        if let name = customDisplayFontName {
            return Font.custom(name, size: 28, relativeTo: .title).weight(.bold)
        }
        return Font.system(.title, design: .rounded, weight: .bold)
    }

    /// Compact hero for onboarding step titles (~26 bold → title).
    public static var heroCompact: Font {
        Font.system(.title, design: .rounded, weight: .bold)
    }

    // MARK: - Section Titles & Headers

    /// Primary section title for screen headers and major group titles (~22 bold).
    public static var title: Font {
        if let name = customDisplayFontName {
            return Font.custom(name, size: 22, relativeTo: .title2).weight(.bold)
        }
        return Font.system(.title2, design: .rounded, weight: .bold)
    }

    /// Secondary section title for sub-cards and grouped items (~20 semibold).
    public static let titleSmall = Font.system(.title3, design: .rounded, weight: .semibold)

    /// Bold secondary section title (~20 bold).
    public static let titleSmallBold = Font.system(.title3, design: .rounded, weight: .bold)

    /// Prominent card headline or list item title (~17 semibold).
    public static let headline = Font.system(.headline, design: .rounded, weight: .semibold)

    /// Bold card / list headline (~17 bold).
    public static let headlineBold = Font.system(.headline, design: .rounded, weight: .bold)

    /// Supporting sub-headline for section intros and card summaries (~15 medium).
    public static let subheadline = Font.system(.subheadline, design: .rounded, weight: .medium)

    /// Semibold sub-headline (~15 semibold).
    public static let subheadlineSemibold = Font.system(.subheadline, design: .rounded, weight: .semibold)

    /// Bold sub-headline (~15 bold).
    public static let subheadlineBold = Font.system(.subheadline, design: .rounded, weight: .bold)

    // MARK: - Body Copy

    /// Standard comfortable body copy (~17 regular).
    public static let body = Font.system(.body, design: .default, weight: .regular)

    /// Emphasized body copy (~17 semibold).
    public static let bodyEmphasized = Font.system(.body, design: .default, weight: .semibold)

    /// Compact body / card description (~16 regular → callout).
    public static let callout = Font.system(.callout, design: .default, weight: .regular)

    /// Semibold callout (~16 semibold).
    public static let calloutSemibold = Font.system(.callout, design: .rounded, weight: .semibold)

    /// Bold callout (~16 bold).
    public static let calloutBold = Font.system(.callout, design: .rounded, weight: .bold)

    // MARK: - Captions, Footnotes & Micro Copy

    /// Metadata tags, mood labels, and category badges (~12 medium).
    public static let caption = Font.system(.caption, design: .default, weight: .medium)

    /// Semibold caption (~12 semibold).
    public static let captionSemibold = Font.system(.caption, design: .default, weight: .semibold)

    /// Bold caption / chip label (~12 bold).
    public static let captionBold = Font.system(.caption, design: .rounded, weight: .bold)

    /// Quiet footnote, timestamp, and legal/version text (~13 regular).
    public static let footnote = Font.system(.footnote, design: .default, weight: .regular)

    /// Medium footnote (~13 medium).
    public static let footnoteMedium = Font.system(.footnote, design: .default, weight: .medium)

    /// Semibold footnote (~13 semibold).
    public static let footnoteSemibold = Font.system(.footnote, design: .default, weight: .semibold)

    /// Bold footnote (~13 bold).
    public static let footnoteBold = Font.system(.footnote, design: .rounded, weight: .bold)

    /// Smallest UI chrome labels (~11 / caption2 medium).
    public static let micro = Font.system(.caption2, design: .rounded, weight: .medium)

    /// Semibold micro label (~11 semibold).
    public static let microSemibold = Font.system(.caption2, design: .rounded, weight: .semibold)

    /// Bold micro / badge (~11 bold).
    public static let microBold = Font.system(.caption2, design: .rounded, weight: .bold)

    /// Button label typography with rounded warmth and high legibility.
    public static let button = Font.system(.headline, design: .rounded, weight: .semibold)

    /// Bold button label (gold primary CTAs).
    public static let buttonBold = Font.system(.headline, design: .rounded, weight: .bold)

    /// Elegant serif typography for inspirational quotes and philosophical reflections.
    public static let quote = Font.system(.title3, design: .serif, weight: .medium)

    /// Empty-state / decorative symbol size (scales with largeTitle).
    public static let symbolLarge = Font.system(.largeTitle, weight: .light)

    /// Mid decorative symbol (scales with title2).
    public static let symbolMedium = Font.system(.title2, weight: .semibold)

    /// Compact symbol for list/icon wells (scales with body).
    public static let symbolSmall = Font.system(.body, weight: .semibold)

    /// Tiny symbol for metadata rows (scales with caption).
    public static let symbolMicro = Font.system(.caption, weight: .semibold)

    // MARK: - Compatibility Aliases

    public static var titleLarge: Font {
        hero
    }

    public static var titleMedium: Font {
        title
    }

    public static var bodyLarge: Font {
        body
    }

    public static var bodyMedium: Font {
        callout
    }

    public static var bodySmall: Font {
        subheadline
    }

    public static var captionSmall: Font {
        footnote
    }
}
