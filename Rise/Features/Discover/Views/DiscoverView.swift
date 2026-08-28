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
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
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
                Image(category.backgroundAssetName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 116, height: 154)
                    .clipped()

                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.35),
                        Color.black.opacity(0.88),
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(category.title)
                        .font(RiseTypography.captionSemibold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineLimit(1)

                    Text("\(category.count)")
                        .font(RiseTypography.microBold)
                        .foregroundStyle(RiseColors.accentTertiary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(RiseColors.accentTertiary.opacity(0.28))
                        .clipShape(Capsule())
                }
                .padding(10)
            }
            .frame(width: 116, height: 154)
            .riseCardStroke(cornerRadius: 16)
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
        let cardWidth: CGFloat = 216
        let cardHeight: CGFloat = 268
        let tagColor = Color(hex: item.tagColorHex)

        return ZStack(alignment: .bottomLeading) {
            Image(item.backgroundAssetName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()

            LinearGradient(
                colors: [
                    Color.black.opacity(0.15),
                    Color.black.opacity(0.55),
                    Color.black.opacity(0.90),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                // Top Tag Badge
                HStack(spacing: 4) {
                    Image(systemName: item.tagSystemIcon)
                        .font(RiseTypography.microBold)
                    Text(item.tag)
                        .font(RiseTypography.microSemibold)
                }
                .foregroundStyle(tagColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(tagColor.opacity(0.28))
                .clipShape(Capsule())

                Spacer(minLength: 0)

                Text(item.quote)
                    .font(RiseTypography.subheadline)
                    .foregroundStyle(RiseColors.textPrimary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)

                if let highlight = item.highlight {
                    Text(highlight)
                        .font(RiseTypography.subheadlineBold)
                        .foregroundStyle(RiseColors.accentGold)
                }

                HStack {
                    Button {
                        RiseHaptic.impact(.light)
                        state.toggleFeaturedLike(item)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: item.isLiked ? "heart.fill" : "heart.fill")
                                .foregroundStyle(item.isLiked ? RiseColors.error : RiseColors.error.opacity(0.8))
                                .riseToggleBounce(trigger: item.isLiked)
                            Text(item.likeCountLabel)
                                .foregroundStyle(RiseColors.textSecondary)
                        }
                        .font(RiseTypography.captionSemibold)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button {
                        RiseHaptic.impact(.light)
                        state.toggleFeaturedSaved(item)
                    } label: {
                        Image(systemName: item.isSaved ? "bookmark.fill" : "bookmark")
                            .font(RiseTypography.calloutSemibold)
                            .foregroundStyle(item.isSaved ? RiseColors.accentSecondary : RiseColors.textPrimary)
                            .riseToggleBounce(trigger: item.isSaved)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(14)
        }
        .frame(width: cardWidth, height: cardHeight)
        .riseCardStroke(cornerRadius: 20)
    }

    // MARK: - "Trending topics" Section

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: "Trending topics") {
                state.didTapSeeAllTrending = true
                appRouter.push(.motivationCategories, on: .discover)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(state.trending) { topic in
                        Button {
                            RiseHaptic.impact(.light)
                            appRouter.push(.morningBoost, on: .discover)
                        } label: {
                            RiseGlassCard(cornerRadius: 16, padding: 10, alwaysShowSpecular: true) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color(hex: topic.accentHex).opacity(0.2))
                                            .frame(width: 38, height: 38)

                                        Image(topic.iconAssetName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(topic.title)
                                            .font(RiseTypography.captionSemibold)
                                            .foregroundStyle(RiseColors.textPrimary)
                                            .lineLimit(1)
                                        Text(topic.viewsLabel)
                                            .font(RiseTypography.micro)
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }

                                    Spacer(minLength: 0)
                                }
                                .frame(width: 156, height: 46)
                            }
                        }
                        .buttonStyle(RisePressableButtonStyle())
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
            }
            .padding(.horizontal, -RiseSpacing.md)
        }
    }
}

#Preview("DiscoverView") {
    DiscoverView()
}
