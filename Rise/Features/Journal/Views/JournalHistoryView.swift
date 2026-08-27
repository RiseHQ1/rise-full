//
//  JournalHistoryView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

public struct JournalHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    @State private var searchQuery = ""

    public init() {}

    private var filteredEntries: [JournalEntryItem] {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.isEmpty {
            return JournalStore.shared.entries
        }
        return JournalStore.shared.entries.filter {
            $0.title.lowercased().contains(trimmed) ||
                $0.content.lowercased().contains(trimmed) ||
                $0.mood.lowercased().contains(trimmed)
        }
    }

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(title: "Journal History", onBack: { dismiss() }) {
                        RiseIconButton(iconName: "plus", accessibilityLabel: "New entry") {
                            router.push(.newJournalEntry, on: appState.selectedTab)
                        }
                    }

                    RiseSearchField(placeholder: "Search entries...", text: $searchQuery)

                    if filteredEntries.isEmpty {
                        RiseEmptyState(
                            iconName: "book.closed",
                            title: "No entries found",
                            message: "Write your first entry or adjust your search filter.",
                            actionTitle: "New Entry"
                        ) {
                            router.push(.newJournalEntry, on: appState.selectedTab)
                        }
                        .padding(.top, RiseSpacing.sm)
                    } else {
                        ForEach(filteredEntries) { entry in
                            Button {
                                RiseHaptic.impact(.light)
                                router.push(.journalEntryDetail(title: entry.title), on: appState.selectedTab)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(entry.assetName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 56, height: 56)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(entry.title)
                                            .font(RiseTypography.subheadlineBold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                            .lineLimit(1)
                                        Text(entry.preview)
                                            .font(RiseTypography.caption)
                                            .foregroundStyle(RiseColors.textSecondary)
                                            .lineLimit(1)
                                        HStack(spacing: 6) {
                                            Text(entry.dateLabel)
                                                .font(RiseTypography.micro)
                                                .foregroundStyle(RiseColors.textMuted)
                                            Text("•")
                                                .font(RiseTypography.micro)
                                                .foregroundStyle(RiseColors.textMuted)
                                            Text(entry.mood)
                                                .font(RiseTypography.microSemibold)
                                                .foregroundStyle(RiseColors.accentPrimary)
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(RiseColors.textMuted)
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
}

#Preview { JournalHistoryView().environment(AppRouter()).environment(AppState()) }
