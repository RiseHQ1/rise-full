//
//  RisePrimaryButton.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Visual style for primary Rise call-to-action buttons.
public enum RisePrimaryButtonStyle {
    /// Violet accent gradient (default design-system CTA).
    case accent
    /// Warm gold gradient matching onboarding and Home primary actions.
    case gold
}

/// Primary call-to-action button for Rise with subtle gradient, press animation, and Dynamic Type.
public struct RisePrimaryButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public let title: String
    public let iconName: String?
    public let isLoading: Bool
    public var style: RisePrimaryButtonStyle
    public let action: () -> Void

    public init(
        _ title: String,
        iconName: String? = nil,
        isLoading: Bool = false,
        style: RisePrimaryButtonStyle = .accent,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.isLoading = isLoading
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            Group {
                if style == .gold {
                    goldLabel
                } else {
                    accentLabel
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: style == .gold ? 50 : 52)
            .background {
                // Keep brand colors when disabled — softens via opacity only
                // (same pattern as Journal "Save Entry").
                switch style {
                case .accent:
                    RiseColors.riseAccentGradient
                case .gold:
                    RiseColors.riseWarmGradient
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: RiseRadius.large, style: .continuous))
            .riseShadow(isEnabled ? (style == .gold ? RiseShadows.goldGlow : RiseShadows.accentGlow) : RiseShadows.elevationLow)
            .opacity(isEnabled ? 1.0 : 0.55)
        }
        .disabled(isLoading || !isEnabled)
        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
        .accessibilityLabel(title)
        .accessibilityAddTraits(isLoading ? [.updatesFrequently] : [])
        .accessibilityIdentifier(
            style == .gold ? RiseAccessibilityID.goldCTA : RiseAccessibilityID.primaryCTA
        )
    }

    private var accentLabel: some View {
        HStack(spacing: RiseSpacing.xs) {
            if isLoading {
                ProgressView()
                    .tint(RiseColors.textOnAccent)
            } else {
                if let iconName {
                    Image(systemName: iconName)
                        .font(RiseTypography.button)
                }
                Text(title)
                    .font(RiseTypography.button)
            }
        }
        .foregroundStyle(RiseColors.textOnAccent)
    }

    private var goldLabel: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .tint(RiseColors.textOnGold)
            } else {
                Text(title)
                    .font(RiseTypography.buttonBold)
                    .foregroundStyle(RiseColors.textOnGold)

                if let iconName {
                    HStack {
                        Spacer()
                        Image(systemName: iconName)
                            .font(RiseTypography.calloutBold)
                            .foregroundStyle(RiseColors.textOnGold)
                            .padding(.trailing, 20)
                    }
                }
            }
        }
    }
}

/// Custom button style for soft interactive spring press animation.
public struct RisePressableButtonStyle: ButtonStyle {
    public let reduceMotion: Bool

    public init(reduceMotion: Bool = false) {
        self.reduceMotion = reduceMotion
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
            .animation(RiseAnimations.interactiveSpring, value: configuration.isPressed)
    }
}

#Preview("RisePrimaryButton - States") {
    VStack(spacing: RiseSpacing.md) {
        RisePrimaryButton("Begin Journey", iconName: "arrow.right") {}
        RisePrimaryButton("Saving Reflections...", isLoading: true) {}
        RisePrimaryButton("Disabled State") {}
            .disabled(true)
    }
    .padding(RiseSpacing.lg)
    .background(RiseColors.backgroundPrimary)
}
