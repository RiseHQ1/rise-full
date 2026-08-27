//
//  EveningReflectionView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

public struct EveningReflectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var wentWell = ""
    @State private var challenge = ""
    @State private var grateful = ""
    @State private var mood = "Calm"

    private let moods = ["Good", "Calm", "Okay", "Low", "Tired"]

    public init() {}

    private var canSave: Bool {
        !wentWell.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            !challenge.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            !grateful.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var body: some View {
        ZStack {
            RiseScreenBackground(imageMaxHeight: 280, bottomScrimOpacity: 0.97)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(title: "Evening Reflection", onBack: { dismiss() })

                    Text("Close the day with honesty and kindness.")
                        .font(RiseTypography.body)
                        .foregroundStyle(RiseColors.textSecondary)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("How was your day?")
                            .font(RiseTypography.calloutBold)
                            .foregroundStyle(RiseColors.textPrimary)
                            .accessibilityAddTraits(.isHeader)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: RiseSpacing.xs) {
                                ForEach(moods, id: \.self) { item in
                                    RiseTag(item, isSelected: mood == item) {
                                        mood = item
                                    }
                                }
                            }
                        }
                    }
                    .padding(14)
                    .riseRichGlass(cornerRadius: RiseRadius.card)

                    reflectionField(title: "What went well today?", text: $wentWell)
                    reflectionField(title: "What challenged you?", text: $challenge)
                    reflectionField(title: "What are you grateful for?", text: $grateful)

                    RisePrimaryButton("Save Reflection", iconName: "checkmark", style: .gold) {
                        saveReflectionAndDismiss()
                    }
                    .accessibilityHint("Saves your evening reflection to your journal.")
                    .disabled(!canSave)
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }

    private func reflectionField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(RiseTypography.subheadlineBold)
                .foregroundStyle(RiseColors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            RiseTextField(placeholder: "Write freely...", text: text, textInputAutocapitalization: .sentences)
                .accessibilityLabel(title)
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.card)
    }

    private func saveReflectionAndDismiss() {
        var parts: [String] = []
        if !wentWell.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append("✨ What went well:\n\(wentWell.trimmingCharacters(in: .whitespacesAndNewlines))")
        }
        if !challenge.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append("🌱 Challenges:\n\(challenge.trimmingCharacters(in: .whitespacesAndNewlines))")
        }
        if !grateful.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append("🙏 Grateful for:\n\(grateful.trimmingCharacters(in: .whitespacesAndNewlines))")
        }

        let fullContent = parts.joined(separator: "\n\n")
        let title = "Evening Reflection — \(Date().formatted(date: .abbreviated, time: .omitted))"

        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)

        let entry = JournalStore.shared.addEntry(
            title: title,
            content: fullContent,
            mood: mood,
            assetName: "onboarding_focus_bg"
        )

        // Asynchronously query Google Gemini for Stoic AI reflection insights
        Task {
            do {
                let payload: [String: Any] = [
                    "mood": mood.uppercased(),
                    "category": "Reflection",
                    "entryText": fullContent
                ]
                let aiResponse: AIReflectionResponseDTO = try await RiseAPIClient.shared.request(
                    endpoint: "ai/reflection",
                    method: "POST",
                    body: payload
                )
                if let insight = aiResponse.insight, !insight.isEmpty {
                    var updatedContent = fullContent
                    if let stoic = aiResponse.stoicPerspective {
                        updatedContent += "\n\n🏛️ Stoic Perspective:\n\(stoic)"
                    }
                    updatedContent += "\n\n💡 Rise AI Insight:\n\(insight)"
                    if let takeaway = aiResponse.actionableTakeaway {
                        updatedContent += "\n\n🎯 Tomorrow's Focus:\n\(takeaway)"
                    }
                    _ = JournalStore.shared.updateEntry(
                        id: entry.id,
                        title: title,
                        content: updatedContent,
                        mood: mood
                    )
                    RiseLogger.info("Gemini AI reflection insight successfully attached to journal entry.")
                }
            } catch {
                RiseLogger.warning("AI reflection insight deferred or offline: \(error.localizedDescription)")
            }
        }

        dismiss()
    }
}

#Preview { EveningReflectionView() }
