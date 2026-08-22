//
//  RisePrimaryButton.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Primary call-to-action button for Rise with subtle gradient, press animation, and Dynamic Type.
public struct RisePrimaryButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public let title: String
    public let iconName: String?
    public let isLoading: Bool
    public let action: () -> Void
    
    public init(
        _ title: String,
        iconName: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
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
            .frame(maxWidth: .infinity)
            .frame(minHeight: 52)
            .background {
                if isEnabled {
                    RiseColors.riseAccentGradient
                } else {
                    LinearGradient(
                        colors: [RiseColors.surfaceSecondary, RiseColors.surfacePrimary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: RiseRadius.large, style: .continuous))
            .riseShadow(isEnabled ? RiseShadows.accentGlow : RiseShadows.elevationLow)
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .disabled(isLoading || !isEnabled)
        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
        .accessibilityLabel(title)
        .accessibilityAddTraits(isLoading ? [.updatesFrequently] : [])
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
