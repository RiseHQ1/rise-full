//
//  HomeHeaderView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Top Home navigation: menu, Rise logo, and notifications with badge.
public struct HomeHeaderView: View {
    public let onMenuTap: () -> Void
    public let onNotificationsTap: () -> Void
    public var showsNotificationBadge: Bool

    public init(
        showsNotificationBadge: Bool = true,
        onMenuTap: @escaping () -> Void,
        onNotificationsTap: @escaping () -> Void
    ) {
        self.showsNotificationBadge = showsNotificationBadge
        self.onMenuTap = onMenuTap
        self.onNotificationsTap = onNotificationsTap
    }

    public var body: some View {
        HStack {
            RiseIconButton(
                iconName: "line.3.horizontal",
                accessibilityLabel: "Menu",
                style: .glass,
                size: RiseIconButtonMetrics.standard,
                action: onMenuTap
            )

            Spacer(minLength: 0)

            Image("rise_sunrise_logo")
                .resizable()
                .scaledToFit()
                .frame(height: 38)
                .accessibilityLabel("Rise")

            Spacer(minLength: 0)

            ZStack(alignment: .topTrailing) {
                RiseIconButton(
                    iconName: "bell",
                    accessibilityLabel: "Notifications",
                    style: .glass,
                    size: RiseIconButtonMetrics.standard,
                    action: onNotificationsTap
                )

                if showsNotificationBadge {
                    Circle()
                        .fill(RiseColors.accentSecondary)
                        .frame(width: 9, height: 9)
                        .overlay {
                            Circle()
                                .stroke(RiseColors.surfaceField.opacity(0.85), lineWidth: 1.5)
                        }
                        .offset(x: -6, y: 6)
                        .accessibilityHidden(true)
                }
            }
        }
    }
}

#Preview("HomeHeaderView") {
    ZStack {
        RiseColors.backgroundPrimary.ignoresSafeArea()
        HomeHeaderView(onMenuTap: {}, onNotificationsTap: {})
            .padding(.horizontal, RiseSpacing.md)
    }
}
