//
//  HomeThoughtCard.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Glass card presenting today's thought with favorite, share, and page indicators.
public struct HomeThoughtCard: View {
    public let thought: HomeState.Thought
    public let thoughtCount: Int
    public let thoughtIndex: Int
    public let isFavorited: Bool
    public let onFavoriteToggle: () -> Void
    public let onShare: () -> Void
    public var onSelectIndex: ((Int) -> Void)?

    @State private var autoSlideTimer: Timer?
    @State private var isUserInteracting = false
    @State private var favoritePulse = 0

    public init(
        thought: HomeState.Thought,
        thoughtCount: Int,
        thoughtIndex: Int,
        isFavorited: Bool,
        onFavoriteToggle: @escaping () -> Void,
        onShare: @escaping () -> Void,
        onSelectIndex: ((Int) -> Void)? = nil
    ) {
        self.thought = thought
        self.thoughtCount = thoughtCount
        self.thoughtIndex = thoughtIndex
        self.isFavorited = isFavorited
        self.onFavoriteToggle = onFavoriteToggle
        self.onShare = onShare
        self.onSelectIndex = onSelectIndex
    }

    public var body: some View {
        RiseContentCard {
            VStack(spacing: RiseSpacing.md) {
                header

                VStack(spacing: 4) {
                    ForEach(Array(thought.lines.enumerated()), id: \.offset) { _, line in
                        Text(line)
                            .font(RiseTypography.titleSmall)
                            .foregroundStyle(RiseColors.textPrimary)
                            .multilineTextAlignment(.center)
                    }

                    Text(thought.highlightedLine)
                        .font(RiseTypography.titleSmallBold)
                        .foregroundStyle(RiseColors.accentGold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                .id(thoughtIndex)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .offset(x: 26)).combined(with: .scale(scale: 0.98)),
                    removal: .opacity.combined(with: .offset(x: -26))
                ))
                .animation(RiseAnimations.modalSpring, value: thoughtIndex)
                .frame(maxWidth: .infinity)
                .padding(.vertical, RiseSpacing.md)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { _ in
                            isUserInteracting = true
                        }
                        .onEnded { value in
                            isUserInteracting = false
                            restartTimer()
                            if value.translation.width < -25 {
                                let next = (thoughtIndex + 1) % max(thoughtCount, 1)
                                withAnimation(RiseAnimations.modalSpring) {
                                    onSelectIndex?(next)
                                }
                            } else if value.translation.width > 25 {
                                let prev = (thoughtIndex - 1 + thoughtCount) % max(thoughtCount, 1)
                                withAnimation(RiseAnimations.modalSpring) {
                                    onSelectIndex?(prev)
                                }
                            }
                        }
                )

                pageIndicators
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    private func startTimer() {
        stopTimer()
        autoSlideTimer = Timer.scheduledTimer(withTimeInterval: 5.5, repeats: true) { _ in
            Task { @MainActor in
                guard !isUserInteracting else { return }
                let next = (thoughtIndex + 1) % max(thoughtCount, 1)
                withAnimation(RiseAnimations.modalSpring) {
                    onSelectIndex?(next)
                }
            }
        }
    }

    private func stopTimer() {
        autoSlideTimer?.invalidate()
        autoSlideTimer = nil
    }

    private func restartTimer() {
        startTimer()
    }

    private var header: some View {
        HStack(spacing: RiseSpacing.xs) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(RiseColors.accentPrimary.opacity(0.35))
                        .frame(width: 28, height: 28)

                    Image(systemName: "quote.opening")
                        .font(RiseTypography.microBold)
                        .foregroundStyle(RiseColors.textPrimary)
                }

                Text(RiseL10n.tr("home.thought.title"))
                    .font(RiseTypography.microSemibold)
                    .tracking(0.6)
                    .foregroundStyle(RiseColors.textSecondary)
            }

            Spacer(minLength: 0)

            HStack(spacing: 8) {
                thoughtIconButton(
                    systemName: isFavorited ? "heart.fill" : "heart",
                    tint: isFavorited ? RiseColors.error : RiseColors.textPrimary,
                    label: isFavorited ? "Unfavorite thought" : "Favorite thought",
                    bounceTrigger: favoritePulse,
                    action: {
                        onFavoriteToggle()
                        favoritePulse += 1
                    }
                )

                thoughtIconButton(
                    systemName: "square.and.arrow.up",
                    tint: RiseColors.textPrimary,
                    label: "Share thought",
                    action: onShare
                )
            }
        }
    }

    private func thoughtIconButton(
        systemName: String,
        tint: Color,
        label: String,
        bounceTrigger: Int? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            Image(systemName: systemName)
                .font(RiseTypography.calloutSemibold)
                .foregroundStyle(tint)
                .modifier(RiseOptionalSymbolBounce(trigger: bounceTrigger))
                .frame(width: 36, height: 36)
                .background {
                    ZStack {
                        Circle()
                            .fill(RiseColors.surfaceField.opacity(0.55))
                        Circle()
                            .fill(.ultraThinMaterial)
                            .opacity(0.60)
                        Circle()
                            .fill(RiseColors.accentPrimary.opacity(0.12))
                    }
                }
                .overlay {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    RiseColors.accentPrimary.opacity(0.40),
                                    RiseColors.borderHairline,
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
                .clipShape(Circle())
        }
        .buttonStyle(RisePressableButtonStyle())
        .accessibilityLabel(label)
        .riseMinimumHitTarget()
    }

    private var pageIndicators: some View {
        let maxVisibleDots = 5
        let totalCount = max(thoughtCount, 1)
        let displayCount = min(totalCount, maxVisibleDots)

        return HStack(spacing: 6) {
            ForEach(0 ..< displayCount, id: \.self) { dotIndex in
                let activeRelativeIndex = thoughtIndex % displayCount
                let isSelected = dotIndex == activeRelativeIndex

                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    let targetIndex = (thoughtIndex / displayCount) * displayCount + dotIndex
                    if targetIndex < totalCount {
                        withAnimation(RiseAnimations.interactiveSpring) {
                            onSelectIndex?(targetIndex)
                        }
                    }
                } label: {
                    Capsule()
                        .fill(isSelected ? RiseColors.accentGold : Color.white.opacity(0.22))
                        .frame(width: isSelected ? 18 : 6, height: 6)
                        .animation(RiseAnimations.interactiveSpring, value: thoughtIndex)
                }
                .buttonStyle(.plain)
                .riseMinimumHitTarget()
                .accessibilityLabel("Thought \(dotIndex + 1) of \(displayCount)")
                .accessibilityAddTraits(isSelected ? [.isSelected] : [])
            }
        }
        .padding(.top, RiseSpacing.xxs)
        .accessibilityElement(children: .contain)
    }
}

#Preview("HomeThoughtCard") {
    ZStack {
        RiseColors.backgroundPrimary.ignoresSafeArea()
        HomeThoughtCard(
            thought: HomeState().currentThought,
            thoughtCount: 3,
            thoughtIndex: 0,
            isFavorited: true,
            onFavoriteToggle: {},
            onShare: {}
        )
        .padding(RiseSpacing.md)
    }
}
