//
//  ProfileSubscreenScaffold.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Shared chrome + scroll layout for Profile preference/account sub-screens.
struct ProfileSubscreenScaffold<Content: View>: View {
    let title: String
    let subtitle: String?
    @ViewBuilder var content: () -> Content
    @Environment(\.dismiss) private var dismiss

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }

    var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(title: title, onBack: { dismiss() })

                    if let subtitle {
                        Text(subtitle)
                            .font(RiseTypography.body)
                            .foregroundStyle(RiseColors.textSecondary)
                    }

                    content()
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

/// Standard preference toggle / action row used inside Profile sub-screens.
struct ProfileSettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var usesAssetIcon: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if usesAssetIcon {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                } else {
                    Image(systemName: icon)
                        .font(RiseTypography.calloutSemibold)
                        .foregroundStyle(RiseColors.accentPrimary)
                        .frame(width: 28, height: 28)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(RiseTypography.subheadlineSemibold)
                    .foregroundStyle(RiseColors.textPrimary)
                Text(subtitle)
                    .font(RiseTypography.caption)
                    .foregroundStyle(RiseColors.textSecondary)
            }

            Spacer(minLength: 0)
        }
    }
}
