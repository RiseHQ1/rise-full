//
//  RiseSectionHeader.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Standardized section title with optional subtitle, trailing action button, and Dynamic Type.
public struct RiseSectionHeader: View {
    public let title: String
    public let subtitle: String?
    public let actionTitle: String?
    public let action: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: RiseSpacing.sm) {
            VStack(alignment: .leading, spacing: RiseSpacing.xxs) {
                Text(title)
                    .font(RiseTypography.title)
                    .foregroundStyle(RiseColors.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(RiseTypography.subheadline)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let actionTitle, let action {
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    action()
                }) {
                    HStack(spacing: RiseSpacing.xxs) {
                        Text(actionTitle)
                            .font(RiseTypography.caption)
                        Image(systemName: "chevron.right")
                            .font(RiseTypography.caption)
                    }
                    .foregroundStyle(RiseColors.accentPrimary)
                    .padding(.vertical, RiseSpacing.xs)
                }
                .accessibilityLabel(actionTitle)
            }
        }
        .padding(.vertical, RiseSpacing.xs)
    }
}

#Preview("RiseSectionHeader") {
    VStack(spacing: RiseSpacing.xl) {
        RiseSectionHeader(
            title: "Daily Motivation",
            subtitle: "Handpicked insights to begin your morning"
        )

        RiseSectionHeader(
            title: "Recent Entries",
            actionTitle: "See All"
        ) {}
    }
    .padding(RiseSpacing.lg)
    .background(RiseColors.backgroundPrimary)
}
