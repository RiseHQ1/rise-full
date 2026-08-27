//
//  RiseGoldCapsuleButton.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI

/// Compact gold CTA used inside cards (Discover help, Journal save chip, Profile continue).
/// Full-width primary actions should use `RisePrimaryButton` instead.
public struct RiseGoldCapsuleButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public let title: String
    public var iconName: String?
    public var height: CGFloat
    public var cornerRadius: CGFloat
    public let action: () -> Void

    public init(
        _ title: String,
        iconName: String? = nil,
        height: CGFloat = 40,
        cornerRadius: CGFloat = RiseRadius.pill,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.height = height
        self.cornerRadius = cornerRadius
        self.action = action
    }

    public var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        } label: {
            HStack(spacing: 6) {
                Text(title)
                    .font(height <= 36 ? RiseTypography.captionBold : RiseTypography.subheadlineBold)
                if let iconName {
                    Image(systemName: iconName)
                        .font(height <= 36 ? RiseTypography.microBold : RiseTypography.captionBold)
                }
            }
            .foregroundStyle(RiseColors.textOnGold)
            .padding(.horizontal, height <= 36 ? 12 : 18)
            .frame(height: max(height, 36))
            .frame(minHeight: RiseIconButtonMetrics.minimumHitTarget > height ? 44 : height)
            .background(RiseColors.riseWarmGradient)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .opacity(isEnabled ? 1 : 0.55)
        }
        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
        .accessibilityLabel(title)
        .accessibilityIdentifier(RiseAccessibilityID.goldCTA)
        .riseMinimumHitTarget(max(height, RiseIconButtonMetrics.minimumHitTarget))
    }
}
