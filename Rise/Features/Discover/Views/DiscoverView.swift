//
//  DiscoverView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Discover tab matching the exact approved design reference.
public struct DiscoverView: View {
    @Environment(AppRouter.self) private var appRouter
    @State private var state = DiscoverState()

    public init() {}

    public var body: some View {
        ZStack {
            backgroundLayer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.lg) {
                    header
                        .riseAppear(delay: 0.0)

                    Button {
                        appRouter.push(.search, on: .discover)
                    } label: {
                        searchBar
                    }
                    .buttonStyle(.plain)
                    .riseAppear(delay: 0.05)

                    // Breathing room for boy hero artwork in top right background
                    Color.clear
                        .frame(height: 24)

                    moodHelpCard
                        .riseAppear(delay: 0.10)

                    categoriesSection
                        .riseAppear(delay: 0.16)

                    featuredSection
                        .riseAppear(delay: 0.22)

                    trendingSection
                        .riseAppear(delay: 0.28)
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.top, RiseSpacing.xs)
                .riseTabBarScrollClearance()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await state.loadServerContent()
        }
    }

    private var backgroundLayer: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                RiseTabBar.ambientBottom

                Image("discover_tab_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                    .clipped()
                    .accessibilityHidden(true)

                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.10),
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
                            RiseTabBar.ambientBottom.opacity(0.25),
                            RiseTabBar.ambientBottom.opacity(0.72),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.34)
                }
                .allowsHitTesting(false)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text("Discover")
                        .font(RiseTypography.display)
                        .foregroundStyle(RiseColors.textPrimary)

                    Text("✨")
                        .font(RiseTypography.display)
                }

                Text("Find content that lifts you up\nand helps you grow.")
                    .font(RiseTypography.subheadline)
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            RiseIconButton(
                iconName: "bell",
                accessibilityLabel: "Notifications",
                style: .glass,
                size: RiseIconButtonMetrics.standard
            ) {
                state.didTapNotifications = true
                appRouter.push(.notifications, on: .discover)
            }
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(RiseColors.accentSecondary)
                    .frame(width: 9, height: 9)
                    .overlay {
                        Circle()
                            .stroke(RiseColors.surfaceField.opacity(0.85), lineWidth: 1.5)
                    }
                    .offset(x: -6, y: 6)
            }
        }
    }

    private var searchBar: some View {
        RiseSearchField(
            placeholder: "Search quotes, topics, authors...",
            text: .constant(""),
            isInteractive: false
        )
        .padding(.trailing, 140)
    }

    // MARK: - "I need something right now" Mood Help Card (Horizontal 2-Column Split)

    private var moodHelpCard: some View {
        RiseContentCard(verticalPadding: 16) {
            HStack(alignment: .center, spacing: 14) {
                // Left Column: Text & CTA Button
                VStack(alignment: .leading, spacing: 6) {
                    Text("I need something right now")
                        .font(RiseTypography.subheadlineBold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Tell us how you're feeling and we'll help you instantly.")
                        .font(RiseTypography.micro)
                        .foregroundStyle(RiseColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        state.didTapGetHelp = true
                        appRouter.push(
                            .needSomethingNow(moodTitle: state.selectedMood?.title ?? "stressed"),
                            on: .discover
                        )
                    } label: {
                        HStack(spacing: 4) {
                            Text("Get help now")
                                .font(RiseTypography.microBold)
                                .foregroundStyle(RiseColors.textOnGold)

                            Image(systemName: "arrow.right")
                                .font(RiseTypography.microBold)
                                .foregroundStyle(RiseColors.textOnGold)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(RiseColors.accentGold)
                        )
                    }
                    .buttonStyle(RisePressableButtonStyle())
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right Column: 4 Mood Circle Buttons
                HStack(spacing: 8) {
                    ForEach(DiscoverState.MoodNeed.allCases) { mood in
                        moodTile(mood)
                    }
                }
            }
        }
    }

    private func moodTile(_ mood: DiscoverState.MoodNeed) -> some View {
        let isSelected = state.selectedMood == mood

        return Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            withAnimation(RiseAnimations.interactiveSpring) {
                state.selectMood(mood)
            }
        } label: {
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .fill(RiseColors.surfacePrimary.opacity(0.85))
                        .frame(width: 44, height: 44)
                        .overlay {
                            Circle()
                                .stroke(isSelected ? RiseColors.accentGold : RiseColors.borderHairline, lineWidth: isSelected ? 1.5 : 1)
                        }

                    Image(mood.iconAssetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }

                Text(mood.title)
                    .font(RiseTypography.micro)
                    .foregroundStyle(isSelected ? RiseColors.textPrimary : RiseColors.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel(mood.title)
    }

    // MARK: - "Browse by category" Section

    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            RiseInlineSectionHeader(title: "Browse by category") {
                state.didTapSeeAllCategories = true
                appRouter.push(.motivationCategories, on: .discover)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(state.categories) { category in
                        categoryCard(category)
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
            }
            .padding(.horizontal, -RiseSpacing.md)
        }
    }

    private func categoryCard(_ category: DiscoverState.CategoryItem) -> some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            appRouter.push(.motivationCategories, on: .discover)
        } label: {
            ZStack(alignment: .bottomLeading) {
                RiseArtworkImage(source: category.backgroundAssetName, fallbackAssetName: "onboarding_motivation_bg")
                    .frame(width: 124, height: 172)
                    .clipped()

                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.12),
                        Color.black.opacity(0.65),
                        Color.black.opacity(0.92),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(category.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineLimit(1)

                    Text("\(category.count)")
                        .font(.system(size: 11.5, weight: .bold))
                        .foregroundStyle(Color(hex: "#A594D1"))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3.5)
                        .background(Color(hex: "#2B204D").opacity(0.88))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
            .frame(width: 124, height: 172)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            }
            .riseShadow(RiseShadows.elevationLow)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(category.title), \(category.count) items")
    }

    // MARK: - "Featured for you" Section

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: "Featured for you") {
                state.didTapSeeAllFeatured = true
                appRouter.push(.morningBoost, on: .discover)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(state.featured) { item in
                        Button {
                            appRouter.push(.morningBoost, on: .discover)
                        } label: {
                            featuredCard(item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
            }
            .padding(.horizontal, -RiseSpacing.md)
        }
    }

    private func featuredCard(_ item: DiscoverState.FeaturedItem) -> some View {
        let cardWidth: CGFloat = 226
        let cardHeight: CGFloat = 300

        return ZStack(alignment: .bottomLeading) {
            RiseArtworkImage(source: item.backgroundAssetName, fallbackAssetName: "onboarding_motivation_bg")
                .frame(width: cardWidth, height: cardHeight)
                .clipped()

            // Dark moody atmosphere vignette
            LinearGradient(
                colors: [
                    Color.black.opacity(0.50),
                    Color.black.opacity(0.20),
                    Color.black.opacity(0.72),
                    Color.black.opacity(0.96),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 0) {
                // Top Tag Badge
                HStack(spacing: 5) {
                    Image(systemName: item.tagSystemIcon)
                        .font(.system(size: 11.5, weight: .bold))
                    Text(item.tag)
                        .font(.system(size: 12.5, weight: .bold))
                }
                .foregroundStyle(pillForeground(for: item.tag))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(pillBackground(for: item.tag))
                )
                .overlay {
                    Capsule()
                        .stroke(pillForeground(for: item.tag).opacity(0.35), lineWidth: 0.8)
                }

                Spacer(minLength: 16)

                // Quote Text & Highlight
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.quote)
                        .font(.system(size: 21, weight: .bold))
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    if let highlight = item.highlight {
                        Text(highlight)
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(Color(hex: "#BCAFE3"))
                    }
                }

                Spacer(minLength: 18)

                // Bottom Engagement Bar
                HStack {
                    Button {
                        RiseHaptic.impact(.light)
                        state.toggleFeaturedLike(item)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color(hex: "#F45B7B"))
                                .riseToggleBounce(trigger: item.isLiked)

                            Text(item.likeCountLabel)
                                .font(.system(size: 14.5, weight: .bold))
                                .foregroundStyle(RiseColors.textPrimary)
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button {
                        RiseHaptic.impact(.light)
                        state.toggleFeaturedSaved(item)
                    } label: {
                        Image(systemName: item.isSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(Color(hex: "#BCAFE3"))
                            .riseToggleBounce(trigger: item.isSaved)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        }
        .riseShadow(RiseShadows.elevationLow)
    }

    private func pillBackground(for tag: String) -> Color {
        let lower = tag.lowercased()
        if lower.contains("boost") || lower.contains("daily") {
            return Color(hex: "#382910") // Rich dark amber
        } else if lower.contains("mind") {
            return Color(hex: "#2E1A4E") // Rich dark purple
        } else if lower.contains("disc") {
            return Color(hex: "#143324") // Rich dark emerald
        }
        return Color(hex: "#251D44")
    }

    private func pillForeground(for tag: String) -> Color {
        let lower = tag.lowercased()
        if lower.contains("boost") || lower.contains("daily") {
            return Color(hex: "#FFC857") // Radiant gold
        } else if lower.contains("mind") {
            return Color(hex: "#C084FC") // Radiant violet
        } else if lower.contains("disc") {
            return Color(hex: "#34D399") // Radiant emerald
        }
        return Color(hex: "#A594D1")
    }

    // MARK: - "Trending topics" Section

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            RiseInlineSectionHeader(title: "Trending topics") {
                state.didTapSeeAllTrending = true
                appRouter.push(.motivationCategories, on: .discover)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(state.trending) { topic in
                        trendingCard(topic)
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
            }
            .padding(.horizontal, -RiseSpacing.md)
        }
    }

    private func trendingCard(_ topic: DiscoverState.TrendingTopic) -> some View {
        Button {
            RiseHaptic.impact(.light)
            appRouter.push(.morningBoost, on: .discover)
        } label: {
            HStack(spacing: 12) {
                trendingIcon(for: topic)
                    .frame(width: 34, height: 34)

                VStack(alignment: .leading, spacing: 3) {
                    Text(topic.title)
                        .font(.system(size: 14.5, weight: .bold))
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(topic.viewsLabel)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#9E97C2"))
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 172, height: 74)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(RiseColors.surfaceField.opacity(0.85))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            }
            .riseShadow(RiseShadows.elevationLow)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(topic.title), \(topic.viewsLabel) views")
    }

    @ViewBuilder
    private func trendingIcon(for topic: DiscoverState.TrendingTopic) -> some View {
        let accentColor = Color(hex: topic.accentHex)
        let lower = topic.title.lowercased()

        if lower.contains("habit") {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(accentColor)
        } else if lower.contains("morning") {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(accentColor)
        } else if lower.contains("fear") {
            Image(systemName: "mountain.2")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(accentColor)
        } else if lower.contains("consistency") {
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(accentColor)
        } else {
            Image(systemName: "sparkles")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(accentColor)
        }
    }
}

#Preview("DiscoverView") {
    DiscoverView()
}
