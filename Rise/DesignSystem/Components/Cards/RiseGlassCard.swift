//
//  RiseGlassCard.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Shared translucent glass card — same surface as onboarding category tiles
/// and Home quick-action chips.
public struct RiseGlassCard<Content: View>: View {
    public var cornerRadius: CGFloat
    public var padding: CGFloat
    public var isSelected: Bool
    public var alwaysShowSpecular: Bool
    public let content: () -> Content

    public init(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = RiseSpacing.md,
        isSelected: Bool = false,
        alwaysShowSpecular: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.isSelected = isSelected
        self.alwaysShowSpecular = alwaysShowSpecular
        self.content = content
    }

    public var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .riseCategoryGlass(
                cornerRadius: cornerRadius,
                isSelected: isSelected,
                alwaysShowSpecular: alwaysShowSpecular
            )
    }
}

#Preview("RiseGlassCard") {
    VStack(spacing: RiseSpacing.md) {
        RiseGlassCard {
            VStack(alignment: .leading, spacing: RiseSpacing.xs) {
                Text("Category Glass Card")
                    .font(RiseTypography.headline)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("Shared dark glass with specular edge — Home + onboarding.")
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
            }
        }

        RiseGlassCard(isSelected: true, alwaysShowSpecular: false) {
            HStack(spacing: RiseSpacing.sm) {
                Image(systemName: "checkmark.circle.fill")
                    .font(RiseTypography.title)
                    .foregroundStyle(RiseColors.accentSecondary)
                VStack(alignment: .leading, spacing: RiseSpacing.xxs) {
                    Text("Selected State")
                        .font(RiseTypography.headline)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text("Accent tint + stronger specular shine.")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }
        }
    }
    .padding(RiseSpacing.lg)
    .background(RiseColors.backgroundPrimary)
}
