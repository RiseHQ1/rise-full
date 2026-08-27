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
            Button(action: onMenuTap) {
                ZStack {
                    RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                        .fill(RiseAudioEngine.shared.isPlaying ? RiseColors.accentGold.opacity(0.25) : RiseColors.surfaceField.opacity(0.85))
                        .overlay {
                            RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                .stroke(RiseAudioEngine.shared.isPlaying ? RiseColors.accentGold : RiseColors.borderHairline, lineWidth: 1)
                        }

                    HStack(spacing: 4) {
                        Image(systemName: RiseAudioEngine.shared.isPlaying ? "waveform" : "waveform.badge.plus")
                            .font(RiseTypography.captionSemibold)
                            .foregroundStyle(RiseAudioEngine.shared.isPlaying ? RiseColors.accentGold : .white)

                        if RiseAudioEngine.shared.isPlaying {
                            Circle()
                                .fill(RiseColors.accentGold)
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .frame(width: 44, height: 44)
            }
            .buttonStyle(RisePressableButtonStyle())
            .accessibilityLabel("Ambient Soundscapes")

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
