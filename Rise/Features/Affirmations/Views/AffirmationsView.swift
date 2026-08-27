//
//  AffirmationsView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Affirmations browse — hero carousel, categories, list, then full-page reader.
public struct AffirmationsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState
    @State private var state = AffirmationsState()
    @State private var sharePayload: RiseSharePayload?

    public init() {}

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.lg) {
                    RiseFeatureChrome(onBack: { dismiss() }) {
                        HStack(spacing: 10) {
                            RiseIconButton(
                                iconName: "magnifyingglass",
                                accessibilityLabel: "Search",
                                style: .glass
                            ) {
                                RiseHaptic.impact(.light)
                                router.push(.search, on: appState.selectedTab)
                            }
                            RiseIconButton(
                                iconName: "plus",
                                accessibilityLabel: "New Affirmation",
                                style: .glass
                            ) {
                                RiseHaptic.impact(.light)
                                state.showCreateSheet = true
                            }
                        }
                    }

                    header
                    heroCarousel
                    categoryFilters

                    if let pick = state.todaysPick {
                        todaysPickCard(pick)
                    }

                    listSection
                    createCard
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $state.showCreateSheet) {
            createSheet
        }
        .sheet(item: $sharePayload) { payload in
            RiseShareSheet(payload: payload)
        }
    }

    private func presentReader(for id: UUID) {
        state.openReader(for: id)
        RiseHaptic.impact(.light)
        router.push(.affirmationReader(initialId: id), on: appState.selectedTab)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Affirmations")
                    .font(RiseTypography.display)
                    .foregroundStyle(RiseColors.textPrimary)
                Image(systemName: "sparkles")
                    .font(RiseTypography.titleSmall)
                    .foregroundStyle(RiseColors.accentSecondary)
            }

            Text("Positive words. Stronger you.")
                .font(RiseTypography.body)
                .foregroundStyle(RiseColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Hero

    private var heroCarousel: some View {
        VStack(spacing: 12) {
            TabView(selection: $state.heroIndex) {
                ForEach(Array(state.heroSlides.enumerated()), id: \.element.id) { index, slide in
                    Button {
                        presentReader(for: slide.linkedItemId)
                    } label: {
                        heroSlide(slide)
                    }
                    .buttonStyle(RisePressableButtonStyle(reduceMotion: reduceMotion))
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 196)

            HStack(spacing: 6) {
                ForEach(0 ..< state.heroSlides.count, id: \.self) { index in
                    Capsule()
                        .fill(
                            index == state.heroIndex
                                ? RiseColors.accentPrimary
                                : Color.white.opacity(0.22)
                        )
                        .frame(width: index == state.heroIndex ? 16 : 6, height: 6)
                        .animation(RiseAnimations.interactiveSpring, value: state.heroIndex)
                }
            }
        }
    }

    private func heroSlide(_ slide: AffirmationsState.HeroSlide) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkle")
                        .font(RiseTypography.microBold)
                        .foregroundStyle(RiseColors.accentSecondary)
                    Text(slide.eyebrow)
                        .font(RiseTypography.captionSemibold)
                        .foregroundStyle(RiseColors.textSecondary)
                }

                Text(slide.text)
                    .font(RiseTypography.titleSmall)
                    .foregroundStyle(RiseColors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .font(RiseTypography.microSemibold)
                        .foregroundStyle(RiseColors.accentPrimary)
                    Text(slide.caption)
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            Image(slide.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 132)
                .clipped()
                .overlay {
                    LinearGradient(
                        colors: [
                            RiseColors.surfaceField.opacity(0.55),
                            Color.clear,
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(RiseColors.surfaceField.opacity(0.92))
        .riseCardStroke(cornerRadius: RiseRadius.card)
        .riseShadow(RiseShadows.elevationMedium)
        .padding(.horizontal, 2)
    }

    // MARK: - Categories

    private var categoryFilters: some View {
        // Edge-to-edge horizontal scroll; inset lives on the chip row.
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: RiseSpacing.xs) {
                ForEach(AffirmationsState.Category.allCases) { category in
                    RiseTag(
                        category.title,
                        iconName: category.systemIcon,
                        isSelected: state.selectedCategory == category
                    ) {
                        RiseHaptic.selection()
                        withAnimation(RiseAnimations.interactiveSpring) {
                            state.selectCategory(category)
                        }
                    }
                }
            }
            .padding(.horizontal, RiseSpacing.md)
        }
        .padding(.horizontal, -RiseSpacing.md)
    }

    // MARK: - Today's pick

    private func todaysPickCard(_ item: AffirmationsState.Item) -> some View {
        let shape = RoundedRectangle(cornerRadius: RiseRadius.card, style: .continuous)

        return ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    RoundedRectangle(cornerRadius: RiseRadius.medium, style: .continuous)
                        .fill(Color(hex: item.accentHex).opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: "sparkles")
                                .font(RiseTypography.headlineBold)
                                .foregroundStyle(Color(hex: item.accentHex))
                        }

                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.text)
                            .font(RiseTypography.calloutBold)
                            .foregroundStyle(RiseColors.textPrimary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("\(item.category.title) · Today's pick")
                            .font(RiseTypography.captionSemibold)
                            .foregroundStyle(RiseColors.accentPrimary.opacity(0.9))
                    }
                }
                .padding(.leading, 14)
                .padding(.vertical, 14)
                .padding(.trailing, 8)
                .frame(maxWidth: .infinity, alignment: .leading)

                Image("onboarding_motivation_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 118)
                    .clipped()
                    .overlay(alignment: .leading) {
                        LinearGradient(
                            colors: [
                                RiseColors.surfaceField.opacity(0.95),
                                RiseColors.surfaceField.opacity(0.35),
                                Color.clear,
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 56)
                    }
            }
            .background(RiseColors.surfaceField.opacity(0.92))
            .clipShape(shape)
            .overlay {
                shape
                    .stroke(
                        LinearGradient(
                            colors: [
                                RiseColors.accentPrimary.opacity(0.45),
                                RiseColors.borderSubtle.opacity(0.80),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }

            Button {
                state.toggleSaved(item.id)
            } label: {
                Image(systemName: state.isSaved(item.id) ? "bookmark.fill" : "bookmark")
                    .font(RiseTypography.footnoteSemibold)
                    .foregroundStyle(RiseColors.accentPrimary)
                    .riseToggleBounce(trigger: state.isSaved(item.id))
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(RiseColors.surfaceField.opacity(0.55)))
                    .overlay {
                        Circle().stroke(RiseColors.accentPrimary.opacity(0.55), lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
            .padding(10)
        }
        .frame(minHeight: 112)
        .contentShape(Rectangle())
        .onTapGesture {
            presentReader(for: item.id)
        }
    }

    // MARK: - List

    private var listSection: some View {
        VStack(alignment: .leading, spacing: RiseSpacing.sm) {
            HStack {
                Text("All affirmations")
                    .font(RiseTypography.titleSmall)
                    .foregroundStyle(RiseColors.textPrimary)
                Spacer()
                HStack(spacing: 6) {
                    Text("\(state.filteredItems.count) affirmations")
                        .font(RiseTypography.footnoteMedium)
                        .foregroundStyle(RiseColors.textSecondary)
                    Image(systemName: "arrow.up.arrow.down")
                        .font(RiseTypography.microSemibold)
                        .foregroundStyle(RiseColors.textMuted)
                }
            }

            VStack(spacing: 10) {
                if state.filteredItems.isEmpty {
                    RiseEmptyState(
                        iconName: "sparkles",
                        title: "No affirmations here",
                        message: "Try another category, or write one that fits this mood."
                    )
                    .padding(.vertical, RiseSpacing.sm)
                } else {
                    ForEach(state.filteredItems) { item in
                        affirmationRow(item)
                    }
                }
            }
        }
    }

    private func affirmationRow(_ item: AffirmationsState.Item) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: RiseRadius.medium, style: .continuous)
                .fill(Color(hex: item.accentHex).opacity(0.18))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: item.systemIcon)
                        .font(RiseTypography.calloutBold)
                        .foregroundStyle(Color(hex: item.accentHex))
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.text)
                    .font(RiseTypography.subheadlineSemibold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                Text("\(item.category.title) · \(item.tagline)")
                    .font(RiseTypography.caption)
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                Button {
                    state.toggleSaved(item.id)
                } label: {
                    Image(systemName: state.isSaved(item.id) ? "bookmark.fill" : "bookmark")
                        .font(RiseTypography.calloutSemibold)
                        .foregroundStyle(
                            state.isSaved(item.id)
                                ? RiseColors.accentSecondary
                                : RiseColors.textMuted
                        )
                        .riseToggleBounce(trigger: state.isSaved(item.id))
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)

                Button {
                    sharePayload = RiseSharePayload(text: item.text)
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(RiseTypography.calloutSemibold)
                        .foregroundStyle(RiseColors.textMuted)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .riseRichGlass(cornerRadius: RiseRadius.large)
        .contentShape(Rectangle())
        .onTapGesture {
            presentReader(for: item.id)
        }
    }

    // MARK: - Create

    private var createCard: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(RiseColors.accentPrimary.opacity(0.22))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "pencil")
                        .font(RiseTypography.calloutBold)
                        .foregroundStyle(RiseColors.accentPrimary)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text("Create your own affirmation")
                    .font(RiseTypography.calloutBold)
                    .foregroundStyle(RiseColors.textPrimary)
                Text("Write a personal line that inspires you.")
                    .font(RiseTypography.caption)
                    .foregroundStyle(RiseColors.textSecondary)
            }

            Spacer(minLength: 8)

            RiseGoldCapsuleButton("Create now", iconName: "arrow.right", height: 34) {
                state.showCreateSheet = true
            }
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.card)
    }

    private var createSheet: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            VStack(alignment: .leading, spacing: RiseSpacing.md) {
                RiseFeatureChrome(title: "New Affirmation", onBack: { state.showCreateSheet = false })

                Text("Write something you want to believe today.")
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)

                RiseTextField(
                    placeholder: "I am…",
                    text: $state.draftAffirmation,
                    textInputAutocapitalization: .sentences
                )

                RisePrimaryButton("Save Affirmation", iconName: "checkmark", style: .gold) {
                    if let id = state.addDraftAffirmation() {
                        presentReader(for: id)
                    }
                }
                .disabled(state.draftAffirmation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
            .padding(.horizontal, RiseSpacing.md)
            .padding(.bottom, RiseSpacing.lg)
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    AffirmationsView()
}
