//
//  SavedMotivationView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

public struct SavedMotivationView: View {
    @Environment(\.dismiss) private var dismiss

    public init() {}

    private var motivationItems: [SavedItem] {
        let all = SavedContentStore.shared.items
        let filtered = all.filter {
            let cat = $0.category.lowercased()
            return cat == "motivation" || cat == "quote"
        }
        return filtered.isEmpty ? all : filtered
    }

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(title: "Saved Motivation", onBack: { dismiss() })

                    if motivationItems.isEmpty {
                        RiseEmptyState(
                            iconName: "quote.opening",
                            title: "No saved motivation yet",
                            message: "Favorite quotes and morning boosts to see them here."
                        )
                        .padding(.top, RiseSpacing.sm)
                    } else {
                        ForEach(motivationItems) { item in
                            VStack(alignment: .leading, spacing: 12) {
                                Image(systemName: "quote.opening")
                                    .foregroundStyle(RiseColors.accentPrimary)
                                Text(item.title)
                                    .font(RiseTypography.button)
                                    .foregroundStyle(RiseColors.textPrimary)
                                if !item.subtitle.isEmpty {
                                    Text(item.subtitle)
                                        .font(RiseTypography.footnote)
                                        .foregroundStyle(RiseColors.textSecondary)
                                }
                                HStack {
                                    Text(item.category)
                                        .font(RiseTypography.captionBold)
                                        .foregroundStyle(RiseColors.accentSecondary)
                                    Spacer()
                                    Button {
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                        withAnimation {
                                            SavedContentStore.shared.remove(id: item.id)
                                        }
                                    } label: {
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(RiseColors.error)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(16)
                            .riseRichGlass(cornerRadius: RiseRadius.card)
                        }
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview { SavedMotivationView() }
