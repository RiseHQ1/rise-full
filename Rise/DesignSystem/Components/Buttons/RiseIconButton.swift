//
//  RiseIconButton.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Style variant for circular icon buttons.
public enum RiseIconButtonStyle {
    case surface
    case glass
}

/// Shared sizing tokens for circular icon controls across Rise.
public enum RiseIconButtonMetrics {
    /// Compact glass control used by onboarding back, Home header, and feature chrome.
    public static let standard: CGFloat = 40
    /// Minimum accessibility hit target around the visual control.
    public static let minimumHitTarget: CGFloat = 44
}

/// Circular or rounded icon button with accessible hit target, rich Liquid Glass background, and haptic feedback.
public struct RiseIconButton: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public let iconName: String
    public let accessibilityLabel: String
    public var style: RiseIconButtonStyle
    public var size: CGFloat
    public var iconColor: Color?
    /// When set, bounces the symbol only when this value changes (typically a tap counter).
    public var bounceTrigger: Int?
    public let action: () -> Void

    public init(
        iconName: String,
        accessibilityLabel: String,
        style: RiseIconButtonStyle = .glass,
        size: CGFloat = RiseIconButtonMetrics.standard,
        iconColor: Color? = nil,
        bounceTrigger: Int? = nil,
        action: @escaping () -> Void
    ) {
        self.iconName = iconName
        self.accessibilityLabel = accessibilityLabel
        self.style = style
        self.size = size
        self.iconColor = iconColor
        self.bounceTrigger = bounceTrigger
        self.action = action
    }

    public var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            Image(systemName: iconName)
                .font(RiseTypography.symbolSmall)
                .foregroundStyle(iconColor ?? RiseColors.textPrimary)
                .modifier(RiseOptionalSymbolBounce(trigger: bounceTrigger))
                .frame(width: size, height: size)
                .background {
                    if style == .glass {
                        ZStack {
                            Circle()
                                .fill(
                                    reduceTransparency
                                        ? RiseColors.surfacePrimary
                                        : RiseColors.surfaceField.opacity(0.55)
                                )
                            if !reduceTransparency {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.60)
                            }
                            Circle()
                                .fill(RiseColors.accentPrimary.opacity(0.12))
                        }
                    } else {
                        Circle()
                            .fill(RiseColors.surfacePrimary)
                    }
                }
                .overlay {
                    Circle()
                        .stroke(
                            style == .glass
                                ? LinearGradient(
                                    colors: [
                                        RiseColors.accentPrimary.opacity(0.40),
                                        RiseColors.borderHairline,
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(colors: [RiseColors.borderSubtle], startPoint: .top, endPoint: .bottom),
                            lineWidth: 1
                        )
                }
                .clipShape(Circle())
                .riseShadow(style == .glass ? RiseShadows.elevationMedium : RiseShadows.elevationLow)
                .frame(
                    width: max(size, RiseIconButtonMetrics.minimumHitTarget),
                    height: max(size, RiseIconButtonMetrics.minimumHitTarget)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier(
            iconName == "chevron.left" ? RiseAccessibilityID.featureBack : "rise.icon.\(iconName)"
        )
    }
}

#Preview("RiseIconButton - Variants") {
    HStack(spacing: RiseSpacing.lg) {
        RiseIconButton(iconName: "bookmark", accessibilityLabel: "Save Item", style: .surface) {}
        RiseIconButton(iconName: "heart.fill", accessibilityLabel: "Favorite", style: .surface) {}
        RiseIconButton(iconName: "chevron.left", accessibilityLabel: "Back", style: .glass) {}
        RiseIconButton(iconName: "gearshape", accessibilityLabel: "Settings", style: .glass) {}
    }
    .padding(RiseSpacing.xl)
    .background(RiseColors.backgroundPrimary)
}
