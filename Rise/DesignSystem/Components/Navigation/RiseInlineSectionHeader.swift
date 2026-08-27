//
//  RiseInlineSectionHeader.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Compact section header with optional subtitle and trailing “See all” action.
public struct RiseInlineSectionHeader: View {
    public let title: String
    public var subtitle: String?
    public var actionTitle: String?
    public var action: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = "See all",
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(RiseTypography.titleSmallBold)
                    .foregroundStyle(RiseColors.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(RiseTypography.footnote)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }

            Spacer(minLength: RiseSpacing.sm)

            if let actionTitle, let action {
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    action()
                }) {
                    HStack(spacing: 2) {
                        Text(actionTitle)
                            .font(RiseTypography.calloutSemibold)
                        Image(systemName: "chevron.right")
                            .font(RiseTypography.captionSemibold)
                    }
                    .foregroundStyle(RiseColors.accentPrimary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
