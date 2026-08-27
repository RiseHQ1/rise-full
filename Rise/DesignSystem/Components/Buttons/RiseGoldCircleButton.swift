//
//  RiseGoldCircleButton.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI

/// Circular gold play / navigate control used by Morning Boost, Need Something Now, and Breathe.
public struct RiseGoldCircleButton: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public let systemName: String
    public var size: CGFloat
    public var iconSize: CGFloat?
    public var usesWarmGradient: Bool
    public var iconOffsetX: CGFloat
    public let action: () -> Void

    public init(
        systemName: String,
        size: CGFloat = 52,
        iconSize: CGFloat? = nil,
        usesWarmGradient: Bool = false,
        iconOffsetX: CGFloat = 0,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.size = size
        self.iconSize = iconSize
        self.usesWarmGradient = usesWarmGradient
        self.iconOffsetX = iconOffsetX
        self.action = action
    }

    public var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        } label: {
            Image(systemName: systemName)
                .font(iconFont)
                .foregroundStyle(RiseColors.textOnGold)
                .offset(x: iconOffsetX)
                .frame(width: size, height: size)
                .background {
                    if usesWarmGradient {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [RiseColors.accentGold, RiseColors.accentSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    } else {
                        Circle()
                            .fill(RiseColors.accentGold)
                    }
                }
        }
        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
        .accessibilityLabel(systemName.contains("pause") ? "Pause" : (systemName.contains("arrow") ? "Continue" : "Play"))
        .accessibilityIdentifier(RiseAccessibilityID.breathePlay)
        .riseMinimumHitTarget()
    }

    private var iconFont: Font {
        // Prefer Dynamic Type tokens; ignore fixed iconSize overrides.
        if size >= 72 {
            return RiseTypography.symbolMedium
        }
        if size >= 44 {
            return RiseTypography.symbolSmall
        }
        return RiseTypography.symbolMicro
    }
}

#Preview {
    HStack(spacing: 20) {
        RiseGoldCircleButton(systemName: "play.fill", iconOffsetX: 2) {}
        RiseGoldCircleButton(systemName: "pause.fill", size: 82, usesWarmGradient: true) {}
        RiseGoldCircleButton(systemName: "arrow.right", size: 28, iconSize: 12) {}
    }
    .padding()
    .background(RiseColors.backgroundAmbient)
}
