//
//  JournalView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Journal tab matching the approved Journal mockup.
public struct JournalView: View {
    @Environment(AppRouter.self) private var appRouter
    @State private var state = JournalState()

    public init() {}

    public var body: some View {
        ZStack {
            backgroundLayer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.lg) {
                    header

                    // Leave room for the boy / desk hero above the streak card.
                    Color.clear
                        .frame(height: 56)

                    streakCard
                    moodSection
                    composeCard
                    promptsSection
                    pastEntriesSection
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.top, RiseSpacing.xs)
                .riseTabBarScrollClearance()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var backgroundLayer: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                RiseTabBar.ambientBottom

                Image("journal_tab_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                    .clipped()
                    .accessibilityHidden(true)

                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.08),
                            Color.clear,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 56)

                    Spacer(minLength: 0)

                    LinearGradient(
                        colors: [
                            Color.clear,
                            RiseTabBar.ambientBottom.opacity(0.22),
                            RiseTabBar.ambientBottom.opacity(0.70),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.32)
                }
                .allowsHitTesting(false)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        // Title up top-left, actions top-right — leaves the journaling boy readable.
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Journal")
                    .font(RiseTypography.display)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("Your space to reflect, release and grow.")
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                RiseIconButton(iconName: "calendar", accessibilityLabel: "Calendar", size: RiseIconButtonMetrics.standard) {
                    state.didTapCalendar = true
                    appRouter.push(.journalHistory, on: .journal)
                }
                RiseIconButton(iconName: "plus", accessibilityLabel: "New entry", size: RiseIconButtonMetrics.standard) {
                    appRouter.push(.newJournalEntry, on: .journal)
                }
            }
        }
    }

    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(RiseColors.accentPrimary.opacity(0.3))
                        .frame(width: 36, height: 36)
                    Image("onboarding_icon_fire")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("7 Day Streak")
                        .font(RiseTypography.calloutBold)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text("Keep showing up!")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }

            HStack(spacing: 8) {
                ForEach(Array(["M", "T", "W", "T", "F", "S", "S"].enumerated()), id: \.offset) { index, day in
                    VStack(spacing: 4) {
                        ZStack {
                            if index < state.streakDaysCompleted {
                                Circle()
                                    .fill(RiseColors.accentPrimary)
                                    .frame(width: 28, height: 28)
                                Image(systemName: "checkmark")
                                    .font(RiseTypography.microBold)
                                    .foregroundStyle(.white)
                            } else {
                                Circle()
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [3]))
                                    .foregroundStyle(RiseColors.borderStrong)
                                    .frame(width: 28, height: 28)
                            }
                        }
                        Text(day)
                            .font(RiseTypography.micro)
                            .foregroundStyle(RiseColors.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.card)
    }

    private var moodSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                Text(RiseL10n.tr("journal.feelingPrompt"))
                    .font(RiseTypography.headlineBold)
                    .foregroundStyle(RiseColors.textPrimary)
                Text(RiseL10n.tr("journal.feelingSubtext"))
                    .font(RiseTypography.footnote)
                    .foregroundStyle(RiseColors.textSecondary)
            }

            HStack(spacing: 8) {
                ForEach(JournalState.Feeling.allCases) { feeling in
                    let isSelected = state.selectedFeeling == feeling

                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        withAnimation(RiseAnimations.interactiveSpring) {
                            state.selectedFeeling = feeling
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(feeling.iconAssetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .accessibilityHidden(true)

                            Text(feeling.title)
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(
                                    isSelected ? RiseColors.textPrimary : RiseColors.textSecondary
                                )
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .riseCategoryGlass(
                            cornerRadius: 14,
                            isSelected: isSelected,
                            alwaysShowSpecular: true
                        )
                    }
                    .buttonStyle(RisePressableButtonStyle())
                    .accessibilityLabel(feeling.title)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
            .animation(RiseAnimations.interactiveSpring, value: state.selectedFeeling)
        }
    }

    private var composeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(RiseColors.accentPrimary.opacity(0.35))
                        .frame(width: 28, height: 28)
                    Image(systemName: "pencil")
                        .font(RiseTypography.captionBold)
                        .foregroundStyle(RiseColors.textPrimary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("What’s on your mind?")
                        .font(RiseTypography.calloutBold)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text("Write freely. There are no right or wrong answers.")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }

            ZStack(alignment: .topLeading) {
                if state.entryText.isEmpty {
                    Text("Start writing...")
                        .font(RiseTypography.callout)
                        .foregroundStyle(RiseColors.textMuted)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .accessibilityHidden(true)
                }

                TextEditor(
                    text: Binding(
                        get: { state.entryText },
                        set: { state.entryText = $0 }
                    )
                )
                .scrollContentBackground(.hidden)
                .font(RiseTypography.callout)
                .foregroundStyle(RiseColors.textPrimary)
                .frame(minHeight: 110)
                .padding(8)
                .accessibilityLabel("Journal entry")
            }
            .background {
                RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                    .fill(RiseColors.surfaceInput.opacity(0.75))
            }
            .overlay {
                RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                    .stroke(RiseColors.borderHairline, lineWidth: 1)
            }

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(RiseTypography.microSemibold)
                    Text("Your journal is private")
                        .font(RiseTypography.micro)
                }
                .foregroundStyle(RiseColors.textSecondary)

                Spacer()

                Text("\(state.wordCount) words")
                    .font(RiseTypography.micro)
                    .foregroundStyle(RiseColors.textMuted)

                RiseGoldCapsuleButton(
                    "Save Entry",
                    height: 34,
                    cornerRadius: 10
                ) {
                    state.saveEntry()
                }
                .accessibilityHint("Saves your journal entry.")
                .disabled(state.entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
    }

    private var promptsSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Need a little help?")
                    .font(RiseTypography.headlineBold)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("Try one of these prompts to get started.")
                    .font(RiseTypography.footnote)
                    .foregroundStyle(RiseColors.textSecondary)
            }

            // Edge-to-edge horizontal scroll; leading/trailing inset lives on the row.
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(state.prompts) { prompt in
                        Button {
                            state.applyPrompt(prompt)
                        } label: {
                            HStack(alignment: .top, spacing: 8) {
                                Image(prompt.iconAssetName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                Text(prompt.text)
                                    .font(RiseTypography.footnoteSemibold)
                                    .foregroundStyle(RiseColors.textPrimary)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: 120, alignment: .leading)
                            }
                            .padding(12)
                            .riseRichGlass(cornerRadius: RiseRadius.large)
                        }
                        .buttonStyle(RisePressableButtonStyle())
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
            }
            .padding(.horizontal, -RiseSpacing.md)
        }
    }

    private var pastEntriesSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: RiseL10n.tr("journal.pastEntries")) {
                state.didTapSeeAll = true
                appRouter.push(.journalHistory, on: .journal)
            }

            VStack(spacing: 10) {
                if state.entries.isEmpty {
                    RiseEmptyState(
                        iconName: "book.closed",
                        title: "No entries yet",
                        message: "Your reflections will show up here as you write.",
                        actionTitle: "New Entry"
                    ) {
                        appRouter.push(.newJournalEntry, on: .journal)
                    }
                    .padding(.vertical, RiseSpacing.sm)
                } else {
                    ForEach(state.entries) { entry in
                        Button {
                            appRouter.push(.journalEntryDetail(title: entry.title), on: .journal)
                        } label: {
                            HStack(spacing: 12) {
                                Image(entry.assetName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipShape(RoundedRectangle(cornerRadius: RiseRadius.medium, style: .continuous))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.title)
                                        .font(RiseTypography.calloutBold)
                                        .foregroundStyle(RiseColors.textPrimary)
                                        .lineLimit(1)
                                    Text(entry.preview)
                                        .font(RiseTypography.caption)
                                        .foregroundStyle(RiseColors.textSecondary)
                                        .lineLimit(1)
                                    HStack(spacing: 4) {
                                        Image(systemName: "calendar")
                                            .font(RiseTypography.microSemibold)
                                        Text(entry.dateLabel)
                                            .font(RiseTypography.micro)
                                    }
                                    .foregroundStyle(RiseColors.textMuted)
                                }

                                Spacer(minLength: 0)

                                VStack(spacing: 8) {
                                    Image(systemName: "lock.fill")
                                        .font(RiseTypography.microSemibold)
                                        .foregroundStyle(RiseColors.textMuted)
                                    Image(systemName: "ellipsis")
                                        .font(RiseTypography.footnoteBold)
                                        .foregroundStyle(RiseColors.textSecondary)
                                        .frame(width: 28, height: 28)
                                        .background(Circle().fill(RiseColors.surfaceField.opacity(0.7)))
                                }
                            }
                            .padding(12)
                            .riseRichGlass(cornerRadius: RiseRadius.large)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .animation(RiseAnimations.modalSpring, value: state.entries)
        }
    }
}

#Preview("JournalView") {
    JournalView()
}
