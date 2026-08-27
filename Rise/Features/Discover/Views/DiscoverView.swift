//
//  DiscoverView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Discover tab matching the approved Discover mockup.
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

                    // Extra breathing room so the boy / desk hero stays readable
                    // between search and the mood-help card.
                    Color.clear
                        .frame(height: 28)

                    moodHelpCard
                        .riseAppear(delay: 0.10)

                    categoriesSection
                        .riseAppear(delay: 0.16)

                    risePacksSection
                        .riseAppear(delay: 0.20)

                    featuredSection
                        .riseAppear(delay: 0.24)

                    trendingSection
                        .riseAppear(delay: 0.28)
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
                // Match shared tab chrome so the bar looks identical to Home.
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
        // Title up top-left, bell top-right — leaves the hero boy readable on the right.
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Discover")
                    .font(RiseTypography.display)
                    .foregroundStyle(RiseColors.textPrimary)

                Text("Find content that lifts you up\nand helps you grow.")
                    .font(RiseTypography.body)
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
                    .offset(x: -6, y: 6)
            }
        }
    }

    private var searchBar: some View {
        RiseSearchField(
            placeholder: RiseL10n.tr("discover.searchPlaceholder"),
            text: .constant(""),
            isInteractive: false
        )
        // Shorten so the boy / book / mug stay visible on the right.
        .padding(.trailing, 148)
    }

    private var moodHelpCard: some View {
        RiseContentCard(verticalPadding: 20) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(RiseL10n.tr("discover.needHelpHeader"))
                        .font(RiseTypography.title)
                        .foregroundStyle(RiseColors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Tell us how you're feeling and we'll help you instantly.")
                        .font(RiseTypography.footnote)
                        .foregroundStyle(RiseColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 10) {
                    ForEach(DiscoverState.MoodNeed.allCases) { mood in
                        moodTile(mood)
                            .frame(maxWidth: .infinity)
                    }
                }
                .animation(RiseAnimations.interactiveSpring, value: state.selectedMood)

                RiseGoldCapsuleButton(RiseL10n.tr("discover.getHelpNow"), iconName: "arrow.right") {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    state.didTapGetHelp = true
                    appRouter.push(
                        .needSomethingNow(moodTitle: state.selectedMood?.title ?? "stressed"),
                        on: .discover
                    )
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
            VStack(spacing: 8) {
                Image(mood.iconAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .riseCategoryGlass(
                        cornerRadius: 14,
                        isSelected: isSelected,
                        alwaysShowSpecular: true
                    )
                    .accessibilityHidden(true)

                Text(mood.title)
                    .font(RiseTypography.microSemibold)
                    .foregroundStyle(
                        isSelected ? RiseColors.textPrimary : RiseColors.textSecondary
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel(mood.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: RiseL10n.tr("discover.categoriesHeader")) {
                state.didTapSeeAllCategories = true
                appRouter.push(.motivationCategories, on: .discover)
            }

            // Edge-to-edge horizontal scroll; leading/trailing inset lives on the row.
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
                    .frame(width: 138, height: 196)
                    .clipped()

                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.35),
                        Color.black.opacity(0.78),
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text(category.title)
                        .font(RiseTypography.subheadlineBold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineLimit(1)

                    Text("\(category.count)")
                        .font(RiseTypography.microBold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(RiseColors.accentPrimary.opacity(0.35))
                        .clipShape(Capsule())
                }
            }
            .frame(width: 138, height: 196)
            .riseCardStroke(cornerRadius: RiseRadius.cardLarge)
            .riseShadow(RiseShadows.elevationLow)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(category.title), \(category.count) items")
    }

    private var risePacksSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: "7-Day Rise Packs") {
                appRouter.push(
                    .packDetail(
                        title: "Morning Reset",
                        category: "Morning",
                        durationDays: 7,
                        isPro: false,
                        artworkAsset: "pack_morning_reset"
                    ),
                    on: .discover
                )
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    packCard(
                        title: "Morning Reset",
                        category: "Morning",
                        isPro: false,
                        artwork: "pack_morning_reset"
                    )
                    packCard(
                        title: "Unstoppable Confidence",
                        category: "Confidence",
                        isPro: true,
                        artwork: "pack_confidence"
                    )
                    packCard(
                        title: "Deep Focus & Flow",
                        category: "Focus",
                        isPro: true,
                        artwork: "pack_deep_focus"
                    )
                    packCard(
                        title: "Evening Reset",
                        category: "Evening",
                        isPro: false,
                        artwork: "pack_evening_reset"
                    )
                    packCard(
                        title: "Radical Self-Love",
                        category: "Self-Love",
                        isPro: true,
                        artwork: "pack_self_love"
                    )
                    packCard(
                        title: "Iron Discipline",
                        category: "Discipline",
                        isPro: true,
                        artwork: "pack_discipline"
                    )
                }
                .padding(.horizontal, RiseSpacing.md)
            }
            .padding(.horizontal, -RiseSpacing.md)
        }
    }

    private func packCard(title: String, category: String, isPro: Bool, artwork: String) -> some View {
        Button {
            RiseHaptic.impact(.light)
            appRouter.push(
                .packDetail(
                    title: title,
                    category: category,
                    durationDays: 7,
                    isPro: isPro,
                    artworkAsset: artwork
                ),
                on: .discover
            )
        } label: {
            ZStack(alignment: .bottomLeading) {
                Image(artwork)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 210)
                    .clipped()

                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.85),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(isPro ? "PRO" : "FREE")
                            .font(.system(size: 9.5, weight: .bold))
                            .foregroundStyle(isPro ? RiseColors.gold : RiseColors.emerald)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(isPro ? RiseColors.gold.opacity(0.2) : RiseColors.emerald.opacity(0.2))
                            .clipShape(Capsule())

                        Spacer()

                        Text("7 DAYS")
                            .font(.system(size: 9.5, weight: .semibold))
                            .foregroundStyle(RiseColors.textSecondary)
                    }

                    Text(title)
                        .font(RiseTypography.subheadlineBold)
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineLimit(2)

                    Text("7 Audio Sessions")
                        .font(RiseTypography.micro)
                        .foregroundStyle(RiseColors.textMuted)
                }
                .padding(12)
            }
            .frame(width: 170, height: 210)
            .riseCardStroke(cornerRadius: RiseRadius.cardLarge)
            .riseShadow(RiseShadows.elevationLow)
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel("\(title), 7 days, \(isPro ? "Pro" : "Free")")
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: "Featured for you") {
                state.didTapSeeAllFeatured = true
                appRouter.push(.morningBoost, on: .discover)
            }

            // Edge-to-edge horizontal scroll; leading/trailing inset lives on the row.
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
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
        let cardWidth: CGFloat = 220
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
                    Color.black.opacity(0.88),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 4) {
                    Image(systemName: item.tagSystemIcon)
                        .font(RiseTypography.microBold)
                    Text(item.tag)
                        .font(RiseTypography.microSemibold)
                }
                .foregroundStyle(tagColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(tagColor.opacity(0.28))
                .clipShape(Capsule())

                Spacer(minLength: 0)

                Text(item.quote)
                    .font(RiseTypography.callout)
                    .foregroundStyle(RiseColors.textPrimary)
                    .lineSpacing(3)

                if let highlight = item.highlight {
                    Text(highlight)
                        .font(RiseTypography.subheadlineBold)
                        .foregroundStyle(RiseColors.accentPrimary)
                }

                HStack {
                    Button {
                        RiseHaptic.impact(.light)
                        state.toggleFeaturedLike(item)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: item.isLiked ? "heart.fill" : "heart")
                                .foregroundStyle(item.isLiked ? RiseColors.error : RiseColors.textPrimary)
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
            .padding(12)
        }
        .frame(width: cardWidth, height: cardHeight)
        .riseCardStroke(cornerRadius: RiseRadius.cardLarge)
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            RiseInlineSectionHeader(title: "Trending topics") {
                state.didTapSeeAllTrending = true
                appRouter.push(.motivationCategories, on: .discover)
            }

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                spacing: 10
            ) {
                ForEach(state.trending) { topic in
                    Button {
                        RiseHaptic.impact(.light)
                        appRouter.push(.morningBoost, on: .discover)
                    } label: {
                        RiseGlassCard(cornerRadius: 16, padding: 12, alwaysShowSpecular: true) {
                            HStack(spacing: 10) {
                                Image(topic.iconAssetName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .accessibilityHidden(true)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(topic.title)
                                        .font(RiseTypography.footnoteBold)
                                        .foregroundStyle(RiseColors.textPrimary)
                                        .lineLimit(1)
                                    Text(topic.viewsLabel)
                                        .font(RiseTypography.micro)
                                        .foregroundStyle(RiseColors.textSecondary)
                                }

                                Spacer(minLength: 0)
                            }
                        }
                    }
                    .buttonStyle(RisePressableButtonStyle())
                }
            }
        }
    }
}

#Preview("DiscoverView") {
    DiscoverView()
}
