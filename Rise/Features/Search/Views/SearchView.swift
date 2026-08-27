//
//  SearchView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

public struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    @State private var query = ""
    @State private var recent = ["discipline", "morning motivation", "overthinking", "focus", "calm"]

    private struct SearchResultItem: Identifiable, Hashable {
        let id = UUID()
        let tag: String
        let title: String
        let subtitle: String
        let asset: String
        let readTime: String
    }

    private var allItems: [SearchResultItem] {
        RiseMotivationCatalog.shared.items.map { record in
            SearchResultItem(
                tag: record.category,
                title: record.quote,
                subtitle: "— \(record.author)",
                asset: record.assetName,
                readTime: "1 min read"
            )
        }
    }

    public init() {}

    private var filteredResults: [SearchResultItem] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.isEmpty {
            return Array(allItems.prefix(30))
        }
        return allItems.filter {
            $0.title.lowercased().contains(trimmed) ||
                $0.subtitle.lowercased().contains(trimmed) ||
                $0.tag.lowercased().contains(trimmed)
        }
    }

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(title: "Search", onBack: { dismiss() })

                    RiseSearchField(
                        placeholder: "Search quotes, topics, authors...",
                        text: $query
                    ) {
                        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty && !recent.contains(trimmed) {
                            recent.insert(trimmed, at: 0)
                        }
                    }

                    if !recent.isEmpty {
                        HStack {
                            Text("Recent searches")
                                .font(RiseTypography.calloutBold)
                                .foregroundStyle(RiseColors.textPrimary)
                                .accessibilityAddTraits(.isHeader)
                            Spacer()
                            Button("Clear all") {
                                RiseHaptic.impact(.light)
                                withAnimation { recent.removeAll() }
                            }
                            .font(RiseTypography.footnoteSemibold)
                            .foregroundStyle(RiseColors.accentPrimary)
                            .accessibilityLabel("Clear all recent searches")
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(recent, id: \.self) { term in
                                    RiseTag(term, iconName: "magnifyingglass", isSelected: query == term) {
                                        query = term
                                    }
                                    .contextMenu {
                                        Button("Remove", role: .destructive) {
                                            recent.removeAll { $0 == term }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Text(query.isEmpty ? "Top results" : "Results for \"\(query)\"")
                        .font(RiseTypography.buttonBold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .accessibilityAddTraits(.isHeader)

                    if filteredResults.isEmpty {
                        RiseEmptyState(
                            iconName: "magnifyingglass",
                            title: "No results found",
                            message: "Try searching for words like 'discipline', 'mindset', or 'focus'."
                        )
                        .padding(.top, RiseSpacing.sm)
                    } else {
                        ForEach(filteredResults) { item in
                            Button {
                                RiseHaptic.impact(.light)
                                router.push(.morningBoost, on: appState.selectedTab)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(item.asset)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 84, height: 96)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous))

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(item.tag)
                                            .font(RiseTypography.caption)
                                            .foregroundStyle(RiseColors.accentPrimary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(Capsule().fill(RiseColors.accentPrimary.opacity(0.2)))
                                            .overlay(Capsule().stroke(RiseColors.accentPrimary.opacity(0.35), lineWidth: 1))

                                        Text(item.title)
                                            .font(RiseTypography.subheadlineBold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                            .lineLimit(2)

                                        Text(item.subtitle)
                                            .font(RiseTypography.caption)
                                            .foregroundStyle(RiseColors.textSecondary)
                                            .lineLimit(2)

                                        HStack(spacing: 8) {
                                            Label("Today", systemImage: "calendar")
                                            Text("•")
                                            Label(item.readTime, systemImage: "clock")
                                        }
                                        .font(RiseTypography.micro)
                                        .foregroundStyle(RiseColors.textMuted)
                                    }

                                    Spacer(minLength: 0)

                                    Image(systemName: "chevron.right")
                                        .font(RiseTypography.footnoteBold)
                                        .foregroundStyle(RiseColors.textMuted)
                                }
                                .padding(12)
                                .riseRichGlass(cornerRadius: RiseRadius.card)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(item.title), \(item.subtitle)")
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

#Preview { SearchView() }
