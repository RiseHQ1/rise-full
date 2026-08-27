//
//  EditStatusQuoteView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Edit the short status quote shown on the Profile tab.
public struct EditStatusQuoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var quote: String = "Small steps today, stronger tomorrow."

    private let suggestions = [
        "Small steps today, stronger tomorrow.",
        "I rise a little more each day.",
        "Progress over perfection.",
        "Calm mind. Clear path. Steady rise.",
    ]

    public init() {}

    public var body: some View {
        ProfileSubscreenScaffold(
            title: "Edit Quote",
            subtitle: "A short line that keeps you grounded."
        ) {
            VStack(alignment: .leading, spacing: RiseSpacing.md) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your quote")
                        .font(RiseTypography.footnoteSemibold)
                        .foregroundStyle(RiseColors.textSecondary)

                    TextField("Write something meaningful…", text: $quote, axis: .vertical)
                        .font(RiseTypography.calloutSemibold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineLimit(3 ... 5)
                        .tint(RiseColors.accentSecondary)
                }
                .padding(14)
                .riseRichGlass(cornerRadius: RiseRadius.card)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Suggestions")
                        .font(RiseTypography.footnoteSemibold)
                        .foregroundStyle(RiseColors.textSecondary)

                    ForEach(suggestions, id: \.self) { item in
                        Button {
                            RiseHaptic.selection()
                            quote = item
                        } label: {
                            HStack {
                                Text(item)
                                    .font(RiseTypography.subheadline)
                                    .foregroundStyle(RiseColors.textPrimary)
                                    .multilineTextAlignment(.leading)
                                Spacer(minLength: 8)
                                if quote == item {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(RiseColors.accentSecondary)
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                    .fill(RiseColors.surfaceInset.opacity(0.65))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(14)
                .riseRichGlass(cornerRadius: RiseRadius.card)

                RisePrimaryButton("Save Quote", iconName: "checkmark", style: .gold) {
                    let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    UserProfileStore.shared.saveStatusQuote(trimmed)
                    dismiss()
                }
                .disabled(quote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear {
            if let saved = UserDefaults.standard.string(forKey: "profile_status_quote"),
               !saved.isEmpty
            {
                quote = saved
            }
        }
    }
}

#Preview {
    EditStatusQuoteView()
}
