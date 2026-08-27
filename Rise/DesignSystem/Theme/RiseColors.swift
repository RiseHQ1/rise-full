//
//  RiseColors.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Centralized semantic color system and gradient tokens for Rise.
///
/// Designed to reflect a calm, premium wellness aesthetic centered on deep navy/cool purple backgrounds,
/// sophisticated violet accents, warm gold highlights, and soft high-contrast typography.
public enum RiseColors {
    // MARK: - Backgrounds

    /// Very deep navy / near-black with a subtle cool purple character (`#070611`).
    public static let backgroundPrimary = Color(hex: "#070611")

    /// Faded dark fill matching Home/tab side ambient (`#12102D`).
    /// Use on feature screens that don't show a hero background image.
    public static let backgroundAmbient = Color(hex: "#12102D")

    /// Slightly elevated dark background for container groupings (`#0E0C1E`).
    public static let backgroundSecondary = Color(hex: "#0E0C1E")

    /// Floating or modal background for sheets and popups (`#16132C`).
    public static let backgroundElevated = Color(hex: "#16132C")

    // MARK: - Surfaces

    /// Primary dark navy/indigo surface for cards and content containers (`#15122B`).
    public static let surfacePrimary = Color(hex: "#15122B")

    /// Nested inset rows inside preference cards (`#161132`).
    public static let surfaceInset = Color(hex: "#161132")

    /// Deep field / glass chip fill used by inputs and chrome (`#100C24`).
    public static let surfaceField = Color(hex: "#100C24")

    /// Darkest text-editor well inside compose cards (`#0A0818`).
    public static let surfaceInput = Color(hex: "#0A0818")

    /// Circular control / dock button fill (`#1A1630`).
    public static let surfaceControl = Color(hex: "#1A1630")

    /// Secondary nested surface or card inset (`#1E1A3C`).
    public static let surfaceSecondary = Color(hex: "#1E1A3C")

    /// Elevated surface for dialogs, floating panels, and action sheets (`#28224F`).
    public static let surfaceElevated = Color(hex: "#28224F")

    /// Translucent surface overlay for glass materials (`Color.white.opacity(0.06)`).
    public static let surfaceGlass = Color.white.opacity(0.06)

    /// Sophisticated violet/purple accent representing mindfulness, growth, and energy (`#8B5CF6`).
    public static let accentPrimary = Color(hex: "#8B5CF6")

    /// Warm golden/yellow accent used sparingly for warmth, highlights, streaks, and achievements (`#F59E0B`).
    public static let accentSecondary = Color(hex: "#F59E0B")

    /// Bright gold highlight for play controls, greeting accents, and progress dots (`#FFD868`).
    public static let accentGold = Color(hex: "#FFD868")

    /// Semantic alias for gold accent.
    public static let gold = accentGold

    /// Semantic alias for emerald success.
    public static let emerald = success

    /// Supporting indigo accent for smooth gradient transitions (`#6366F1`).
    public static let accentTertiary = Color(hex: "#6366F1")
    public static let indigo = accentTertiary

    // MARK: - Text & Content

    /// Soft white for primary headings and body copy (`#F8F7FC`).
    public static let textPrimary = Color(hex: "#F8F7FC")

    /// Muted lavender/gray for secondary text, subtitles, and supporting labels (`#A5A1C8`).
    public static let textSecondary = Color(hex: "#A5A1C8")

    /// Deeper muted lavender/gray for timestamps, footnotes, and inactive elements (`#6E6A94`).
    public static let textMuted = Color(hex: "#6E6A94")

    /// High-contrast text for buttons with accent backgrounds (`#FFFFFF`).
    public static let textOnAccent = Color(hex: "#FFFFFF")

    /// Near-black text for gold / warm CTAs (`#090616`).
    public static let textOnGold = Color(hex: "#090616")

    // MARK: - Borders & Hairlines

    /// Delicate subtle border for content card outlines (`#2A254D`).
    public static let borderSubtle = Color(hex: "#2A254D")

    /// Default card / input hairline stroke (`borderSubtle` @ 70%).
    public static let borderHairline = borderSubtle.opacity(0.7)

    /// Soft divider / nested stroke (`borderSubtle` @ 55%).
    public static let borderSoft = borderSubtle.opacity(0.55)

    /// Stronger border for selected items, focused inputs, or highlighted cards (`#49407D`).
    public static let borderStrong = Color(hex: "#49407D")

    // MARK: - Status & Feedback

    /// Calm emerald for positive progress, streaks, and completion states (`#10B981`).
    public static let success = Color(hex: "#10B981")

    /// Warm amber for alerts and gentle reminders (`#F59E0B`).
    public static let warning = Color(hex: "#F59E0B")

    /// Soft coral red for errors and critical notices (`#EF4444`).
    public static let error = Color(hex: "#EF4444")

    // MARK: - Semantic Gradients

    /// Subtle vertical ambient background gradient.
    public static let riseBackgroundGradient = LinearGradient(
        colors: [Color(hex: "#070611"), Color(hex: "#120F29"), Color(hex: "#070611")],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Vibrant violet-to-indigo gradient for primary CTA buttons and hero highlights.
    public static let riseAccentGradient = LinearGradient(
        colors: [Color(hex: "#8B5CF6"), Color(hex: "#6366F1")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Warm amber-to-gold gradient for streak milestones, sun highlights, and achievements.
    public static let riseWarmGradient = LinearGradient(
        colors: [Color(hex: "#FBBF24"), Color(hex: "#F59E0B"), Color(hex: "#D97706")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Subtle ambient glow gradient for background radial or linear lighting.
    public static let riseGlowGradient = RadialGradient(
        gradient: Gradient(colors: [Color(hex: "#8B5CF6").opacity(0.25), Color.clear]),
        center: .center,
        startRadius: 10,
        endRadius: 160
    )

    /// Deep surface card gradient for featured/hero containers.
    public static let riseCardGradient = LinearGradient(
        colors: [Color(hex: "#1B1736"), Color(hex: "#131027")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Compatibility Aliases

    public static var primaryGradient: LinearGradient {
        riseAccentGradient
    }

    public static var goldGradient: LinearGradient {
        riseWarmGradient
    }

    public static var backgroundGradient: LinearGradient {
        riseBackgroundGradient
    }

    public static var borderHighlight: Color {
        borderStrong
    }
}
