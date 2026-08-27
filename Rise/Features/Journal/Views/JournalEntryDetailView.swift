//
//  JournalEntryDetailView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

public struct JournalEntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    public let title: String

    @State private var showDeleteConfirm = false
    @State private var sharePayload: String?

    public init(title: String) {
        self.title = title
    }

    private var entry: JournalEntryItem? {
        JournalStore.shared.entry(forTitle: title)
    }

    public var body: some View {
        let entryItem = entry ?? JournalEntryItem(
            title: title,
            content: "Finished my morning routine and stayed focused on the things that mattered. It wasn't a perfect day, but I showed up with intention and that feels like enough.",
            mood: "Good",
            assetName: "onboarding_motivation_bg"
        )

        ZStack {
            RiseScreenBackground(imageMaxHeight: 260, bottomScrimOpacity: 0.97)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(onBack: { dismiss() }) {
                        Menu {
                            Button(role: .destructive) {
                                showDeleteConfirm = true
                            } label: {
                                Label("Delete Entry", systemImage: "trash")
                            }
                            Button {
                                RiseHaptic.impact(.light)
                                sharePayload = "\(entryItem.title)\n\n\(entryItem.content)"
                            } label: {
                                Label("Share Entry", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            RiseIconButton(iconName: "ellipsis", accessibilityLabel: "More") {}
                        }
                    }

                    Text(entryItem.title)
                        .font(RiseTypography.hero)
                        .foregroundStyle(RiseColors.textPrimary)

                    Label(entryItem.dateLabel, systemImage: "calendar")
                        .font(RiseTypography.footnoteMedium)
                        .foregroundStyle(RiseColors.textSecondary)

                    Text(entryItem.content)
                        .font(RiseTypography.callout)
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineSpacing(5)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .riseRichGlass(cornerRadius: RiseRadius.card)

                    HStack {
                        Label("Mood: \(entryItem.mood)", systemImage: "face.smiling")
                        Spacer()
                        Label("Private", systemImage: "lock.fill")
                    }
                    .font(RiseTypography.footnoteSemibold)
                    .foregroundStyle(RiseColors.textSecondary)
                    .padding(14)
                    .riseRichGlass(cornerRadius: RiseRadius.control)
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .alert("Delete Entry?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                RiseHaptic.notification(.warning)
                if let e = entry {
                    JournalStore.shared.deleteEntry(id: e.id)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this journal entry? This action cannot be undone.")
        }
        .sheet(isPresented: Binding(
            get: { sharePayload != nil },
            set: {
                if !$0 {
                    sharePayload = nil
                }
            }
        )) {
            if let text = sharePayload {
                RiseShareSheet(items: [text])
            }
        }
    }
}

#Preview { JournalEntryDetailView(title: "Grateful for the little wins today.") }
