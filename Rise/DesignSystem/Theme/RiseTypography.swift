//
//  RiseTypography.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Centralized typography system for Rise with full Dynamic Type support and custom font readiness.
///
/// By default, provides Apple's rounded system fonts for warm, modern UI elements and serif fonts
/// for editorial reflections and quotes. The system is designed to allow future custom brand and display fonts
/// (e.g. for hero headings and affirmations) to be introduced seamlessly.
public enum RiseTypography {
    // MARK: - Custom Font Configuration Hook
    /// Future custom display font family name (e.g. "PlusJakartaSans", "Outfit", or "PlayfairDisplay").
    /// When set to `nil`, standard Apple system fonts with Dynamic Type are utilized.
    public static var customDisplayFontName: String? = nil
    
    // MARK: - Display & Hero
    /// Large confident heading for splash, hero intros, and milestone celebrations.
    public static var display: Font {
        if let name = customDisplayFontName {
            return Font.custom(name, size: 34, relativeTo: .largeTitle).weight(.bold)
        }
        return Font.system(.largeTitle, design: .rounded, weight: .bold)
    }
    
    /// Hero editorial heading for daily themes and feature banners.
    public static var hero: Font {
        if let name = customDisplayFontName {
            return Font.custom(name, size: 28, relativeTo: .title).weight(.bold)
        }
        return Font.system(.title, design: .rounded, weight: .bold)
    }
    
    // MARK: - Section Titles & Headers
    /// Primary section title for screen headers and major group titles.
    public static var title: Font {
        if let name = customDisplayFontName {
            return Font.custom(name, size: 22, relativeTo: .title2).weight(.bold)
        }
        return Font.system(.title2, design: .rounded, weight: .bold)
    }
    
    /// Secondary section title for sub-cards and grouped items.
    public static let titleSmall = Font.system(.title3, design: .rounded, weight: .semibold)
    
    /// Prominent card headline or list item title.
    public static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
    
    /// Supporting sub-headline for section intros and card summaries.
    public static let subheadline = Font.system(.subheadline, design: .rounded, weight: .medium)
    
    // MARK: - Body Copy
    /// Standard comfortable body copy for affirmations, descriptions, and reflections.
    public static let body = Font.system(.body, design: .default, weight: .regular)
    
    /// Emphasized body copy for key phrases and callouts.
    public static let bodyEmphasized = Font.system(.body, design: .default, weight: .semibold)
    
    /// Secondary callout text for compact descriptions and cards.
    public static let callout = Font.system(.callout, design: .default, weight: .regular)
    
    // MARK: - Captions, Footnotes & Micro Copy
    /// Metadata tags, mood labels, and category badges.
    public static let caption = Font.system(.caption, design: .default, weight: .medium)
    
    /// Quiet footnote, timestamp, and legal/version text.
    public static let footnote = Font.system(.footnote, design: .default, weight: .regular)
    
    /// Button label typography with rounded warmth and high legibility.
    public static let button = Font.system(.headline, design: .rounded, weight: .semibold)
    
    /// Elegant serif typography for inspirational quotes and philosophical reflections.
    public static let quote = Font.system(.title3, design: .serif, weight: .medium)
    
    // MARK: - Compatibility Aliases
    public static var titleLarge: Font { hero }
    public static var titleMedium: Font { title }
    public static var bodyLarge: Font { body }
    public static var bodyMedium: Font { callout }
    public static var bodySmall: Font { subheadline }
    public static var captionSmall: Font { footnote }
}
