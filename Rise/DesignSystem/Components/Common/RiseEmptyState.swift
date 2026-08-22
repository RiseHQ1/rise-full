//
//  RiseEmptyState.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Accessible empty state container with icon/illustration, title, description, and optional action button.
/// Supports standard SF Symbols as well as future custom Rise illustration assets.
public struct RiseEmptyState: View {
    public let iconName: String
    public let isSystemIcon: Bool
    public let title: String
    public let message: String
    public let actionTitle: String?
    public let action: (() -> Void)?
    
    public init(
        iconName: String,
        isSystemIcon: Bool = true,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.isSystemIcon = isSystemIcon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: RiseSpacing.lg) {
            ZStack {
                Circle()
                    .fill(RiseColors.surfacePrimary)
                    .frame(width: 80, height: 80)
                    .overlay {
                        Circle()
                            .stroke(RiseColors.borderSubtle, lineWidth: 1)
                    }
                    .riseShadow(RiseShadows.accentGlow)
                
                if isSystemIcon {
                    Image(systemName: iconName)
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(RiseColors.accentPrimary)
                } else {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                }
            }
            .padding(.bottom, RiseSpacing.xs)
            
            VStack(spacing: RiseSpacing.xs) {
                Text(title)
                    .font(RiseTypography.title)
                    .foregroundStyle(RiseColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, RiseSpacing.md)
            }
            
            if let actionTitle, let action {
                RisePrimaryButton(actionTitle, action: action)
                    .padding(.top, RiseSpacing.sm)
                    .padding(.horizontal, RiseSpacing.lg)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(RiseSpacing.xl)
        .accessibilityElement(children: .combine)
    }
}

#Preview("RiseEmptyState") {
    VStack {
        RiseEmptyState(
            iconName: "book.closed",
            title: "No Journal Entries Yet",
            message: "Reflect on your thoughts and write your first entry to nurture mindfulness.",
            actionTitle: "New Entry"
        ) {}
    }
    .frame(maxHeight: .infinity)
    .background(RiseColors.backgroundPrimary)
}
