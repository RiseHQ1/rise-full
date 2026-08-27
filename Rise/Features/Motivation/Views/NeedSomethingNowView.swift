//
//  NeedSomethingNowView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// “I need something right now” support screen (IKSRN mockup).
public struct NeedSomethingNowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppState.self) private var appState

    public let moodTitle: String
    @State private var sharePayload: String?

    public init(moodTitle: String = "stressed") {
        self.moodTitle = moodTitle
    }

    public var body: some View {
        ZStack {
            RiseScreenBackground(imageMaxHeight: 340, topScrimOpacity: 0.2, bottomScrimOpacity: 0.96)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.lg) {
                    RiseFeatureChrome(
                        onBack: { dismiss() },
                        trailing: {
                            Menu {
                                Button {
                                    RiseHaptic.impact(.light)
                                    let prompt = "It’s okay to feel \(moodTitle.lowercased()). "
                                        + "You don't have to have it all together. Take a breath, reset, and take it one step at a time. — Rise"
                                    sharePayload = prompt
                                } label: {
                                    Label("Share Reminder", systemImage: "square.and.arrow.up")
                                }

                                Button {
                                    RiseHaptic.impact(.light)
                                    SavedContentStore.shared.toggleSave(
                                        title: "Feeling \(moodTitle.capitalized)",
                                        subtitle: "Support & mindful reset",
                                        category: "Motivation",
                                        assetName: "onboarding_motivation_bg"
                                    )
                                } label: {
                                    Label(
                                        SavedContentStore.shared.isSaved(title: "Feeling \(moodTitle.capitalized)") ? "Saved in Favorites" : "Save to Favorites",
                                        systemImage: SavedContentStore.shared.isSaved(title: "Feeling \(moodTitle.capitalized)") ? "heart.fill" : "heart"
                                    )
                                }
                            } label: {
                                RiseIconButton(iconName: "ellipsis", accessibilityLabel: "More") {}
                            }
                        }
                    )

                    VStack(alignment: .leading, spacing: 10) {
                        (Text("It’s okay to feel ")
                            .foregroundStyle(RiseColors.textPrimary)
                            + Text(moodTitle.lowercased() + ".")
                            .foregroundStyle(RiseColors.accentPrimary))
                            .font(RiseTypography.hero)

                        Text("You don't have to have it all together. Take a breath, reset, and take it one step at a time.")
                            .font(RiseTypography.body)
                            .foregroundStyle(RiseColors.textSecondary)
                            .lineSpacing(3)
                    }

                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(RiseColors.accentPrimary)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Remember")
                                .font(RiseTypography.calloutBold)
                                .foregroundStyle(RiseColors.accentPrimary)
                            Text("This feeling is temporary. You are not alone. You’re stronger than you think.")
                                .font(RiseTypography.footnote)
                                .foregroundStyle(RiseColors.textSecondary)
                        }
                    }
                    .padding(14)
                    .riseRichGlass(cornerRadius: RiseRadius.large)

                    tryThisCard
                    breatheFeatureCard
                    recommendedSection
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
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

    private var tryThisCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(RiseColors.accentPrimary)
                Text("In this moment, try this")
                    .font(RiseTypography.buttonBold)
                    .foregroundStyle(RiseColors.textPrimary)
            }
            .padding(.bottom, 12)

            momentRow(
                icon: "wind",
                tint: "#8B5CF6",
                title: "Take a deep breath",
                subtitle: "A 2-minute breathing exercise"
            ) {
                appRouter.push(.breatheReset, on: appState.selectedTab)
            }
            Divider().background(RiseColors.borderSubtle)
            momentRow(
                icon: "square.and.pencil",
                tint: "#EC4899",
                title: "Release your thoughts",
                subtitle: "Write down what’s on your mind"
            ) {
                appRouter.push(.newJournalEntry, on: appState.selectedTab)
            }
            Divider().background(RiseColors.borderSubtle)
            momentRow(
                icon: "play.fill",
                tint: "#3B82F6",
                title: "Listen to calm",
                subtitle: "Soothing audio to help you relax"
            ) {
                appRouter.push(.morningBoost, on: appState.selectedTab)
            }
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
    }

    private func momentRow(
        icon: String,
        tint: String,
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            RiseHaptic.impact(.light)
            action()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: RiseRadius.medium, style: .continuous)
                        .fill(Color(hex: tint).opacity(0.28))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .foregroundStyle(RiseColors.textPrimary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(RiseTypography.subheadlineSemibold)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text(subtitle)
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(RiseTypography.captionBold)
                    .foregroundStyle(RiseColors.textOnGold)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(RiseColors.accentGold))
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var breatheFeatureCard: some View {
        Button {
            RiseHaptic.impact(.medium)
            appRouter.push(.breatheReset, on: appState.selectedTab)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(RiseColors.accentPrimary.opacity(0.25))
                        .frame(width: 64, height: 64)
                    Image(systemName: "leaf.fill")
                        .font(RiseTypography.symbolMedium)
                        .foregroundStyle(RiseColors.accentPrimary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Breathe & reset")
                        .font(RiseTypography.subheadlineBold)
                        .foregroundStyle(RiseColors.accentPrimary)
                    HStack(spacing: 4) {
                        Text("Box Breathing")
                            .font(RiseTypography.calloutSemibold)
                            .foregroundStyle(RiseColors.textPrimary)
                        Image(systemName: "info.circle")
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textMuted)
                    }
                    Text("4-4-4-4 • 2 min")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }

                Spacer()

                Image(systemName: "play.fill")
                    .font(RiseTypography.headlineBold)
                    .foregroundStyle(RiseColors.textOnGold)
                    .frame(width: 52, height: 52)
                    .background(Circle().fill(RiseColors.accentGold))
            }
            .padding(14)
            .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
        }
        .buttonStyle(.plain)
    }

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: "Recommended for you") {}

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(["onboarding_motivation_bg", "onboarding_focus_bg", "splash_sunrise_scene"], id: \.self) { asset in
                        Button {
                            RiseHaptic.impact(.light)
                            appRouter.push(.morningBoost, on: appState.selectedTab)
                        } label: {
                            ZStack(alignment: .bottomLeading) {
                                Image(asset)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 160, height: 110)
                                    .clipped()
                                LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .center, endPoint: .bottom)
                                HStack(spacing: 4) {
                                    Image(systemName: "speaker.wave.2.fill")
                                    Text("3 min")
                                }
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(.white)
                                .padding(8)
                            }
                            .frame(width: 160, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(RisePressableButtonStyle())
                    }
                }
            }
        }
    }
}

#Preview { NeedSomethingNowView() }
