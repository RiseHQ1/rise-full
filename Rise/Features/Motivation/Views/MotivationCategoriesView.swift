//
//  MotivationCategoriesView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

public struct MotivationCategoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    private struct Category: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let count: Int
        let icon: String
        let bg: String
        let blurb: String
        let tag: String
    }

    private let categories: [Category] = [
        Category(
            title: "Motivation",
            count: 154,
            icon: "onboarding_icon_motivation",
            bg: "onboarding_motivation_bg",
            blurb: "Fuel for the days you need a push.",
            tag: "Recommended"
        ),
        Category(
            title: "Discipline",
            count: 96,
            icon: "onboarding_icon_discipline",
            bg: "onboarding_focus_bg",
            blurb: "Stay consistent when motivation fades.",
            tag: "Picked for you"
        ),
        Category(
            title: "Focus",
            count: 84,
            icon: "onboarding_icon_target",
            bg: "onboarding_improvements_bg",
            blurb: "Cut the noise and protect your attention.",
            tag: "Keep going"
        ),
        Category(
            title: "Self Growth",
            count: 112,
            icon: "onboarding_icon_growth",
            bg: "onboarding_summary_bg",
            blurb: "Small steps toward who you’re becoming.",
            tag: "Recommended"
        ),
        Category(
            title: "Mindset",
            count: 88,
            icon: "onboarding_icon_brain",
            bg: "splash_sunrise_scene",
            blurb: "Reframe the story you tell yourself.",
            tag: "Picked for you"
        ),
        Category(
            title: "Well-being",
            count: 74,
            icon: "onboarding_icon_heart",
            bg: "onboarding_welcome_bg",
            blurb: "Calm, care, and emotional steadiness.",
            tag: "Keep going"
        ),
    ]

    @State private var sortAscending = true

    public init() {}

    private var sortedCategories: [Category] {
        categories.sorted {
            sortAscending
                ? $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
                : $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending
        }
    }

    private var featured: [Category] {
        Array(categories.prefix(3))
    }

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.lg) {
                    RiseFeatureChrome(onBack: { dismiss() }) {
                        RiseIconButton(
                            iconName: "magnifyingglass",
                            accessibilityLabel: "Search",
                            style: .glass
                        ) {
                            RiseHaptic.impact(.light)
                            router.push(.search, on: appState.selectedTab)
                        }
                    }

                    header
                    forYouSection
                    allCategoriesSection
                    surpriseBanner
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text("Motivation Categories")
                    .font(RiseTypography.display)
                    .foregroundStyle(RiseColors.textPrimary)
                Image(systemName: "sparkles")
                    .font(RiseTypography.titleSmall)
                    .foregroundStyle(RiseColors.accentPrimary)
            }

            Text("What do you need today?")
                .font(RiseTypography.title)
                .foregroundStyle(RiseColors.textPrimary)

            Text("Explore something that matches where you are right now.")
                .font(RiseTypography.body)
                .foregroundStyle(RiseColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - For You

    private var forYouSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: "For You", actionTitle: nil)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(featured) { item in
                        featuredCard(item)
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
            }
            .padding(.horizontal, -RiseSpacing.md)
        }
    }

    private func featuredCard(_ item: Category) -> some View {
        Button {
            openCategory()
        } label: {
            ZStack(alignment: .bottomLeading) {
                Image(item.bg)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 300)
                    .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.35), .black.opacity(0.82)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 10) {
                    RiseTag(item.tag, isSelected: true) {}

                    Spacer(minLength: 0)

                    Text(item.title)
                        .font(RiseTypography.title)
                        .foregroundStyle(RiseColors.textPrimary)

                    Text(item.blurb)
                        .font(RiseTypography.footnoteMedium)
                        .foregroundStyle(RiseColors.textSecondary)
                        .lineLimit(2)

                    HStack {
                        Label("\(item.count) items", systemImage: "calendar")
                            .font(RiseTypography.captionSemibold)
                            .foregroundStyle(RiseColors.textMuted)

                        Spacer(minLength: 0)

                        circleArrow
                    }
                }
                .padding(16)
            }
            .frame(width: 260, height: 300)
            .riseCardStroke(cornerRadius: RiseRadius.cardLarge)
        }
        .buttonStyle(RisePressableButtonStyle())
    }

    // MARK: - All Categories

    private var allCategoriesSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            HStack(spacing: 10) {
                Text("All Categories")
                    .font(RiseTypography.titleSmall)
                    .foregroundStyle(RiseColors.textPrimary)

                Spacer(minLength: 0)

                RiseTag(sortAscending ? "A-Z" : "Z-A", iconName: "chevron.down", isSelected: true) {
                    sortAscending.toggle()
                }
            }

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(sortedCategories) { item in
                    categoryCard(item)
                }
            }
        }
    }

    private func categoryCard(_ item: Category) -> some View {
        Button {
            openCategory()
        } label: {
            ZStack(alignment: .bottomLeading) {
                Image(item.bg)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 168)
                    .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.78)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 8) {
                    Image(item.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)

                    Spacer(minLength: 0)

                    Text(item.title)
                        .font(RiseTypography.calloutBold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineLimit(1)

                    HStack {
                        Text("\(item.count) items")
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textSecondary)

                        Spacer(minLength: 0)

                        circleArrow
                    }
                }
                .padding(12)
            }
            .frame(height: 168)
            .riseCardStroke(cornerRadius: RiseRadius.card)
        }
        .buttonStyle(RisePressableButtonStyle())
    }

    // MARK: - Surprise

    private var surpriseBanner: some View {
        VStack(spacing: 12) {
            HStack(spacing: 14) {
                Image(systemName: "sparkle")
                    .font(RiseTypography.symbolMedium)
                    .foregroundStyle(RiseColors.accentSecondary)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(RiseColors.surfaceField.opacity(0.75)))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Can't decide?")
                        .font(RiseTypography.subheadlineBold)
                        .foregroundStyle(RiseColors.textPrimary)
                    Text("Let us surprise you with something perfect for today.")
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .padding(14)
            .riseRichGlass(cornerRadius: RiseRadius.card)

            RisePrimaryButton("Surprise me", iconName: "sparkles") {
                openCategory()
            }
        }
    }

    // MARK: - Shared

    private var circleArrow: some View {
        Image(systemName: "arrow.right")
            .font(RiseTypography.captionBold)
            .foregroundStyle(RiseColors.textPrimary)
            .frame(width: 30, height: 30)
            .background(Circle().fill(RiseColors.surfaceField.opacity(0.75)))
            .overlay(Circle().stroke(RiseColors.borderSoft, lineWidth: 1))
    }

    private func openCategory() {
        RiseHaptic.impact(.light)
        router.push(.morningBoost, on: appState.selectedTab)
    }
}

#Preview { MotivationCategoriesView() }
