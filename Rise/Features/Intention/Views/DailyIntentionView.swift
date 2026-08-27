//
//  DailyIntentionView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Daily intention multi-step form matching the Daily intention mockup.
public struct DailyIntentionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    @State private var intention = ""
    @State private var smallAction = ""
    @State private var why = ""
    @State private var selectedFocus = "Mindset"

    private let focuses: [(title: String, icon: String)] = [
        ("Mindset", "onboarding_icon_brain"),
        ("Focus", "onboarding_icon_target"),
        ("Discipline", "onboarding_icon_discipline"),
        ("Self Growth", "onboarding_icon_growth"),
        ("Well-being", "onboarding_icon_heart"),
        ("Other", "onboarding_icon_lightbulb"),
    ]

    public init() {}

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(title: "Daily Intention", onBack: { dismiss() }) {
                        EmptyView()
                    }

                    stepCard {
                        labeledHeader(number: 1, icon: "onboarding_icon_target", title: "What’s your intention for today?")
                        limitedEditor(text: $intention, placeholder: "e.g. I intend to stay focused and finish what I start.", limit: 120)
                    }

                    stepCard {
                        labeledHeader(number: 2, icon: "onboarding_icon_sprout_soil", title: "Choose your focus area")
                        Text("What will you focus on the most today?")
                            .font(RiseTypography.footnote)
                            .foregroundStyle(RiseColors.textSecondary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(focuses, id: \.title) { item in
                                    Button {
                                        RiseHaptic.selection()
                                        selectedFocus = item.title
                                    } label: {
                                        VStack(spacing: 8) {
                                            Image(item.icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 28, height: 28)
                                            Text(item.title)
                                                .font(RiseTypography.microSemibold)
                                                .foregroundStyle(RiseColors.textPrimary)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.7)
                                        }
                                        .frame(width: 72, height: 78)
                                        .background(RiseColors.surfaceField.opacity(0.7))
                                        .clipShape(RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                                                .stroke(
                                                    selectedFocus == item.title
                                                        ? RiseColors.accentSecondary
                                                        : RiseColors.accentPrimary.opacity(0.3),
                                                    lineWidth: selectedFocus == item.title ? 1.5 : 1
                                                )
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel(item.title)
                                    .accessibilityAddTraits(selectedFocus == item.title ? [.isSelected] : [])
                                }
                            }
                        }
                    }

                    stepCard {
                        labeledHeader(number: 3, icon: "onboarding_icon_fitness", title: "One small action I will take")
                        Text("What’s one small step you will take today?")
                            .font(RiseTypography.footnote)
                            .foregroundStyle(RiseColors.textSecondary)
                        suggestRow(text: $smallAction, placeholder: "e.g. Read for 20 minutes, Go for a walk…")
                    }

                    stepCard {
                        labeledHeader(number: 4, icon: "paperplane.fill", title: "Why does this matter to you?", systemIcon: true)
                        Text("A quick reminder of your ‘why’.")
                            .font(RiseTypography.footnote)
                            .foregroundStyle(RiseColors.textSecondary)
                        suggestRow(text: $why, placeholder: "Because...")
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .foregroundStyle(RiseColors.accentSecondary)
                                .accessibilityHidden(true)
                            Text("Your intention for today")
                                .font(RiseTypography.headline)
                                .foregroundStyle(RiseColors.accentSecondary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isHeader)

                        Text(intention.isEmpty ? "Write your intention above to see it here." : intention)
                            .font(RiseTypography.headline)
                            .foregroundStyle(RiseColors.textPrimary)

                        RisePrimaryButton("Set Intention", iconName: "arrow.right", style: .gold) {
                            UserProfileStore.shared.saveDailyIntention(
                                text: intention,
                                focus: selectedFocus,
                                action: smallAction,
                                why: why
                            )
                            router.push(.intentionComplete, on: appState.selectedTab)
                        }
                        .accessibilityHint("Saves your daily intention and continues.")
                        .disabled(intention.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(16)
                    .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let saved = UserProfileStore.shared.todayIntention, !saved.isEmpty {
                intention = saved
                selectedFocus = UserProfileStore.shared.todayIntentionFocus ?? "Mindset"
                smallAction = UserProfileStore.shared.todayIntentionAction ?? ""
                why = UserProfileStore.shared.todayIntentionWhy ?? ""
            }
        }
    }

    private func stepCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .riseRichGlass(cornerRadius: RiseRadius.card)
    }

    private func labeledHeader(number: Int, icon: String, title: String, systemIcon: Bool = false) -> some View {
        HStack(spacing: 8) {
            if systemIcon {
                Image(systemName: icon)
                    .foregroundStyle(RiseColors.accentPrimary)
                    .accessibilityHidden(true)
            } else {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
            }
            Text("\(number). \(title)")
                .font(RiseTypography.headline)
                .foregroundStyle(RiseColors.textPrimary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }

    private func limitedEditor(text: Binding<String>, placeholder: String, limit: Int) -> some View {
        VStack(alignment: .trailing, spacing: 6) {
            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .font(RiseTypography.callout)
                        .foregroundStyle(RiseColors.textMuted)
                        .padding(12)
                }
                TextEditor(text: text)
                    .scrollContentBackground(.hidden)
                    .font(RiseTypography.callout)
                    .foregroundStyle(RiseColors.textPrimary)
                    .frame(minHeight: 88)
                    .padding(8)
                    .onChange(of: text.wrappedValue) { _, newValue in
                        if newValue.count > limit {
                            text.wrappedValue = String(newValue.prefix(limit))
                        }
                    }
            }
            .background(RoundedRectangle(cornerRadius: RiseRadius.control).fill(RiseColors.surfaceInput.opacity(0.8)))
            .overlay(RoundedRectangle(cornerRadius: RiseRadius.control).stroke(RiseColors.borderHairline, lineWidth: 1))

            Text("\(text.wrappedValue.count) / \(limit)")
                .font(RiseTypography.micro)
                .foregroundStyle(RiseColors.textMuted)
        }
    }

    private func suggestRow(text: Binding<String>, placeholder: String) -> some View {
        HStack(spacing: 10) {
            limitedEditor(text: text, placeholder: placeholder, limit: 120)
            Button {} label: {
                Image("onboarding_icon_lightbulb")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .frame(width: 52, height: 52)
                    .background(RoundedRectangle(cornerRadius: RiseRadius.control).fill(RiseColors.surfaceField.opacity(0.8)))
                    .overlay(RoundedRectangle(cornerRadius: RiseRadius.control).stroke(RiseColors.accentSecondary.opacity(0.5), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview { DailyIntentionView().environment(AppRouter()).environment(AppState()) }
