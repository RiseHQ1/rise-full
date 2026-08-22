//
//  RiseGlassCard.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Translucent card container using native Liquid Glass styling.
///
/// Designed for floating actions, modal sheets, contextual overlays, and select interactive tiles.
public struct RiseGlassCard<Content: View>: View {
    public var cornerRadius: CGFloat
    public var padding: CGFloat
    public var tintColor: Color?
    public let content: () -> Content
    
    public init(
        cornerRadius: CGFloat = RiseRadius.large,
        padding: CGFloat = RiseSpacing.md,
        tintColor: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.tintColor = tintColor
        self.content = content
    }
    
    public var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .riseGlass(
                cornerRadius: cornerRadius,
                tintColor: tintColor,
                strokeColor: RiseColors.borderSubtle.opacity(0.8)
            )
            .riseShadow(RiseShadows.elevationMedium)
    }
}

#Preview("RiseGlassCard") {
    VStack(spacing: RiseSpacing.md) {
        RiseGlassCard {
            VStack(alignment: .leading, spacing: RiseSpacing.xs) {
                Text("Native Liquid Glass Card")
                    .font(RiseTypography.headline)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("Translucent material surface with delicate hairline border for floating controls.")
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
            }
        }
        
        RiseGlassCard(tintColor: RiseColors.accentPrimary) {
            HStack(spacing: RiseSpacing.sm) {
                Image(systemName: "sparkles")
                    .font(RiseTypography.title)
                    .foregroundStyle(RiseColors.accentPrimary)
                VStack(alignment: .leading, spacing: RiseSpacing.xxs) {
                    Text("Tinted Glass Card")
                        .font(RiseTypography.headline)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text("Subtly tinted with accent color.")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }
        }
    }
    .padding(RiseSpacing.lg)
    .background(RiseColors.backgroundPrimary)
}
