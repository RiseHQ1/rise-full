//
//  SavedView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

public struct SavedView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    public init() {}

    private var items: [SavedItem] {
        SavedContentStore.shared.items
    }

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(title: "Saved", onBack: { dismiss() }) {
                        RiseIconButton(
                            iconName: "sparkles",
                            accessibilityLabel: "Saved motivation",
                            style: .glass
                        ) {
                            router.push(.savedMotivation, on: appState.selectedTab)
                        }
                    }

                    Text("Your favorite content, all in one place.")
                        .font(RiseTypography.body)
                        .foregroundStyle(RiseColors.textSecondary)

                    if items.isEmpty {
                        RiseEmptyState(
                            iconName: "bookmark",
                            title: "No saved items yet",
                            message: "Tap the bookmark or heart icon on quotes, affirmations, and exercises to save them here."
                        )
                        .padding(.top, RiseSpacing.lg)
                    } else {
                        ForEach(items) { item in
                            Button {
                                handleItemTap(item)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(item.assetName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 72)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.category)
                                            .font(RiseTypography.microBold)
                                            .foregroundStyle(RiseColors.accentPrimary)
                                        Text(item.title)
                                            .font(RiseTypography.subheadlineSemibold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                            .lineLimit(2)
                                    }

                                    Spacer(minLength: 0)

                                    Button {
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                        withAnimation {
                                            SavedContentStore.shared.remove(id: item.id)
                                        }
                                    } label: {
                                        Image(systemName: "bookmark.fill")
                                            .foregroundStyle(RiseColors.accentSecondary)
                                            .padding(8)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(12)
                                .riseRichGlass(cornerRadius: RiseRadius.large)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }

    private func handleItemTap(_ item: SavedItem) {
        RiseHaptic.impact(.light)
        switch item.category.lowercased() {
        case "affirmation":
            router.push(.affirmations, on: appState.selectedTab)
        case "breathwork":
            router.push(.breatheReset, on: appState.selectedTab)
        default:
            router.push(.morningBoost, on: appState.selectedTab)
        }
    }
}

#Preview { SavedView().environment(AppRouter()).environment(AppState()) }
