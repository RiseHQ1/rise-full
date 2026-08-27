//
//  RiseContentCard.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Primary content card surface used by Home (Thought, Intention, Quick Actions)
/// and Discover mood help — one widget so every screen stays uniform.
public struct RiseContentCard<Content: View>: View {
    public var cornerRadius: CGFloat
    public var horizontalPadding: CGFloat
    public var verticalPadding: CGFloat
    public let content: () -> Content

    public init(
        cornerRadius: CGFloat = 26,
        horizontalPadding: CGFloat = 18,
        verticalPadding: CGFloat = 18,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.content = content
    }

    public var body: some View {
        content()
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .riseRichGlass(cornerRadius: cornerRadius)
            .riseShadow(RiseShadows.elevationMedium)
    }
}

#Preview("RiseContentCard") {
    ZStack {
        RiseColors.backgroundPrimary.ignoresSafeArea()
        RiseContentCard {
            VStack(alignment: .leading, spacing: RiseSpacing.sm) {
                Text("Shared content card")
                    .font(RiseTypography.headline)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("Same rich glass as Home Thought / Intention cards.")
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
            }
        }
        .padding(RiseSpacing.md)
    }
}
