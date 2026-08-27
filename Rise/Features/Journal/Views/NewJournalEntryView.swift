//
//  NewJournalEntryView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

public struct NewJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var bodyText = ""
    @State private var mood = "Good"

    public init() {}

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            !bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private let moods = ["Good", "Calm", "Okay", "Low"]

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            VStack(spacing: RiseSpacing.md) {
                RiseFeatureChrome(title: "New Entry", onBack: { dismiss() })

                RiseTextField(
                    placeholder: "Title (optional)",
                    text: $title,
                    textInputAutocapitalization: .sentences
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: RiseSpacing.xs) {
                        ForEach(moods, id: \.self) { item in
                            RiseTag(item, isSelected: mood == item) {
                                mood = item
                            }
                        }
                    }
                }

                ZStack(alignment: .topLeading) {
                    if bodyText.isEmpty {
                        Text("Start writing freely... There are no right or wrong answers.")
                            .font(RiseTypography.callout)
                            .foregroundStyle(RiseColors.textMuted)
                            .padding(16)
                            .accessibilityHidden(true)
                    }
                    TextEditor(text: $bodyText)
                        .scrollContentBackground(.hidden)
                        .font(RiseTypography.callout)
                        .foregroundStyle(RiseColors.textPrimary)
                        .padding(12)
                        .accessibilityLabel("Journal entry")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .riseRichGlass(cornerRadius: RiseRadius.large)

                RisePrimaryButton("Save Entry", iconName: "checkmark", style: .gold) {
                    saveAndDismiss()
                }
                .accessibilityHint("Saves your journal entry.")
                .disabled(!canSave)
            }
            .padding(.horizontal, RiseSpacing.md)
            .padding(.bottom, RiseSpacing.lg)
        }
        .navigationBarHidden(true)
    }

    private func saveAndDismiss() {
        guard canSave else { return }
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)

        let finalTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? (bodyText.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n").first.map(String.init) ?? "Journal entry")
            : title

        _ = JournalStore.shared.addEntry(
            title: finalTitle,
            content: bodyText,
            mood: mood,
            assetName: "onboarding_motivation_bg"
        )
        dismiss()
    }
}

#Preview { NewJournalEntryView() }
