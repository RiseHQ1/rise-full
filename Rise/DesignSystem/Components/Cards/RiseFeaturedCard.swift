//
//  RiseFeaturedCard.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Highlighted hero/featured card with rich subtle gradient and optional accent glow.
///
/// Designed for daily intentions, active meditation sessions, and milestone spotlights.
public struct RiseFeaturedCard<Content: View>: View {
    public var cornerRadius: CGFloat
    public var padding: CGFloat
    public var isGoldAccent: Bool
    public let content: () -> Content

    public init(
        cornerRadius: CGFloat = RiseRadius.extraLarge,
        padding: CGFloat = RiseSpacing.lg,
        isGoldAccent: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.isGoldAccent = isGoldAccent
        self.content = content
    }

    public var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                ZStack {
                    RiseColors.riseCardGradient

                    if isGoldAccent {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(RiseColors.accentSecondary.opacity(0.4), lineWidth: 1.5)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [RiseColors.accentPrimary.opacity(0.6), RiseColors.borderSubtle],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .riseShadow(isGoldAccent ? RiseShadows.warmGlow : RiseShadows.accentGlow)
    }
}

#Preview("RiseFeaturedCard") {
    VStack(spacing: RiseSpacing.lg) {
        RiseFeaturedCard {
            VStack(alignment: .leading, spacing: RiseSpacing.sm) {
                HStack {
                    Text("DAILY INTENTION")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.accentPrimary)
                    Spacer()
                    Image(systemName: "sparkles")
                        .foregroundStyle(RiseColors.accentPrimary)
                }

                Text("“I meet today's moments with quiet strength and boundless clarity.”")
                    .font(RiseTypography.quote)
                    .foregroundStyle(RiseColors.textPrimary)
            }
        }

        RiseFeaturedCard(isGoldAccent: true) {
            VStack(alignment: .leading, spacing: RiseSpacing.sm) {
                HStack {
                    Text("7-DAY MINDFULNESS STREAK")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.accentSecondary)
                    Spacer()
                    Image(systemName: "sun.max.fill")
                        .foregroundStyle(RiseColors.accentSecondary)
                }

                Text("You have unlocked consistent morning presence.")
                    .font(RiseTypography.headline)
                    .foregroundStyle(RiseColors.textPrimary)
            }
        }
    }
    .padding(RiseSpacing.lg)
    .background(RiseColors.backgroundPrimary)
}
