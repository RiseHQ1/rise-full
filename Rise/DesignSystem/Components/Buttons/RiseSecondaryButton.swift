//
//  RiseSecondaryButton.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Secondary surface/outlined button for quieter actions and dismissals.
public struct RiseSecondaryButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public let title: String
    public let iconName: String?
    public let action: () -> Void
    
    public init(
        _ title: String,
        iconName: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: RiseSpacing.xs) {
                if let iconName {
                    Image(systemName: iconName)
                        .font(RiseTypography.button)
                }
                Text(title)
                    .font(RiseTypography.button)
            }
            .foregroundStyle(isEnabled ? RiseColors.textPrimary : RiseColors.textMuted)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 52)
            .background(RiseColors.surfacePrimary)
            .overlay {
                RoundedRectangle(cornerRadius: RiseRadius.large, style: .continuous)
                    .stroke(isEnabled ? RiseColors.borderSubtle : RiseColors.borderSubtle.opacity(0.4), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: RiseRadius.large, style: .continuous))
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .disabled(!isEnabled)
        .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
        .accessibilityLabel(title)
    }
}

#Preview("RiseSecondaryButton - States") {
    VStack(spacing: RiseSpacing.md) {
        RiseSecondaryButton("Not Now", iconName: "xmark") {}
        RiseSecondaryButton("Disabled Secondary") {}
            .disabled(true)
    }
    .padding(RiseSpacing.lg)
    .background(RiseColors.backgroundPrimary)
}
