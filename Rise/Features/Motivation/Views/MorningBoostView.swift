//
//  MorningBoostView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Morning Boost / inspiration detail screen.
public struct MorningBoostView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    @Environment(AppState.self) private var appState

    @State private var progress: Double = 0.28
    @State private var isPlaying = false
    @State private var playbackSpeed: Double = 1.0
    @State private var timer: Timer?
    @State private var sharePayload: String?
    @State private var savePulse = 0

    private let titleText = "Small choices every day create a powerful future."

    public init() {}

    private var isSaved: Bool {
        SavedContentStore.shared.isSaved(title: titleText)
    }

    public var body: some View {
        ZStack {
            RiseScreenBackground(imageMaxHeight: 300, bottomScrimOpacity: 0.97)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    RiseFeatureChrome(onBack: { dismiss() }) {
                        RiseIconButton(
                            iconName: isSaved ? "bookmark.fill" : "bookmark",
                            accessibilityLabel: "Save",
                            bounceTrigger: savePulse
                        ) {
                            toggleSave()
                        }
                    }

                    Text(titleText)
                        .font(RiseTypography.hero)
                        .foregroundStyle(RiseColors.textPrimary)

                    HStack(spacing: 10) {
                        Image("onboarding_icon_sprout_soil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Rise Inspiration")
                                .font(RiseTypography.calloutBold)
                                .foregroundStyle(RiseColors.textPrimary)
                            Text("Motivation • 3 min read")
                                .font(RiseTypography.caption)
                                .foregroundStyle(RiseColors.textSecondary)
                        }
                    }

                    HStack(spacing: 0) {
                        actionItem(
                            isSaved ? "heart.fill" : "heart",
                            isSaved ? "Saved" : "Save",
                            tint: isSaved ? RiseColors.error : RiseColors.accentPrimary,
                            bounceTrigger: savePulse
                        ) {
                            toggleSave()
                        }
                        Divider().frame(height: 36).background(RiseColors.borderSubtle)
                        actionItem("paperplane", "Share") {
                            sharePayload = "\(titleText) — via Rise"
                        }
                        Divider().frame(height: 36).background(RiseColors.borderSubtle)
                        actionItem("bubble.left", "Reflect") {
                            router.push(.newJournalEntry, on: appState.selectedTab)
                        }
                        Divider().frame(height: 36).background(RiseColors.borderSubtle)
                        actionItem("sparkles", "Affirm") {
                            router.push(.affirmations, on: appState.selectedTab)
                        }
                    }
                    .padding(.vertical, 10)
                    .riseRichGlass(cornerRadius: RiseRadius.large)

                    quoteCard
                    audioCard

                    RiseInlineSectionHeader(title: "You might also like") {}
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(["onboarding_motivation_bg", "onboarding_focus_bg", "onboarding_summary_bg"], id: \.self) { asset in
                                Button {
                                    RiseHaptic.impact(.light)
                                } label: {
                                    Image(asset)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 140, height: 170)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .overlay(alignment: .topTrailing) {
                                            Image(systemName: "bookmark")
                                                .font(RiseTypography.captionSemibold)
                                                .foregroundStyle(.white)
                                                .padding(10)
                                        }
                                }
                                .buttonStyle(RisePressableButtonStyle())
                            }
                        }
                    }
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onDisappear {
            stopAudioTimer()
            RiseAudioEngine.shared.stopSoundscape()
        }
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

    private func toggleSave() {
        SavedContentStore.shared.toggleSave(
            title: titleText,
            subtitle: "Rise Inspiration",
            category: "Motivation",
            assetName: "onboarding_motivation_bg"
        )
        savePulse += 1
    }

    private func actionItem(
        _ icon: String,
        _ title: String,
        tint: Color = RiseColors.accentPrimary,
        bounceTrigger: Int? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            RiseHaptic.impact(.light)
            action()
        }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(RiseTypography.calloutSemibold)
                    .foregroundStyle(tint)
                    .modifier(RiseOptionalSymbolBounce(trigger: bounceTrigger))
                Text(title)
                    .font(RiseTypography.micro)
                    .foregroundStyle(RiseColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "quote.opening")
                        .font(RiseTypography.title)
                        .foregroundStyle(RiseColors.accentPrimary.opacity(0.8))
                    Text("You don’t have to be perfect. You just have to be willing. Willing to try, willing to learn, and willing to grow.\n\nOne decision, one step, one day at a time. That’s how it happens.")
                        .font(RiseTypography.subheadline)
                        .foregroundStyle(RiseColors.textPrimary)
                        .lineSpacing(3)
                }

                Image("onboarding_icon_sprout_soil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
            }

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text("Affirm it")
                    }
                    .font(RiseTypography.footnoteBold)
                    .foregroundStyle(RiseColors.accentPrimary)
                    Text("Repeat this to yourself today.")
                        .font(RiseTypography.micro)
                        .foregroundStyle(RiseColors.textSecondary)
                }
                Spacer()
                Text("I choose to grow every day.")
                    .font(RiseTypography.captionSemibold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(RiseColors.accentPrimary.opacity(0.5)))
            }
        }
        .padding(16)
        .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
    }

    private var audioCard: some View {
        let totalSeconds = 165
        let currentSeconds = Int(Double(totalSeconds) * progress)
        let elapsedMin = currentSeconds / 60
        let elapsedSec = currentSeconds % 60

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: isPlaying ? "waveform" : "headphones")
                        .foregroundStyle(isPlaying ? RiseColors.accentSecondary : RiseColors.accentPrimary)
                        .symbolEffect(.variableColor.iterative, isActive: isPlaying)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("Listen to this")
                                .font(RiseTypography.subheadlineBold)
                                .foregroundStyle(RiseColors.textPrimary)
                            if isPlaying {
                                Text("Playing")
                                    .font(RiseTypography.microBold)
                                    .foregroundStyle(RiseColors.accentSecondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(RiseColors.accentSecondary.opacity(0.18))
                                    .clipShape(Capsule())
                                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                            }
                        }
                        Text("Let these words sink in.")
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textSecondary)
                    }
                }
                Spacer()
                Button {
                    cyclePlaybackSpeed()
                } label: {
                    Text(String(format: "%.1fx", playbackSpeed))
                        .font(RiseTypography.microBold)
                        .foregroundStyle(RiseColors.accentSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(RiseColors.surfaceField.opacity(0.85)))
                }
                .buttonStyle(.plain)
            }
            .animation(RiseAnimations.interactiveSpring, value: isPlaying)

            HStack(spacing: 12) {
                VStack(spacing: 6) {
                    Slider(value: $progress, in: 0 ... 1)
                        .tint(RiseColors.accentPrimary)
                    HStack {
                        Text(String(format: "%d:%02d", elapsedMin, elapsedSec))
                        Spacer()
                        Text("2:45")
                    }
                    .font(RiseTypography.micro)
                    .foregroundStyle(RiseColors.textMuted)
                }

                Button {
                    toggleAudio()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(RiseTypography.headlineBold)
                        .foregroundStyle(RiseColors.textOnGold)
                        .frame(width: 52, height: 52)
                        .background(Circle().fill(RiseColors.accentGold))
                        .scaleEffect(isPlaying ? 1.05 : 1.0)
                        .animation(RiseAnimations.interactiveSpring, value: isPlaying)
                }
                .buttonStyle(RisePressableButtonStyle())
            }
        }
        .padding(14)
        .riseRichGlass(cornerRadius: RiseRadius.cardLarge)
    }

    private func cyclePlaybackSpeed() {
        RiseHaptic.selection()
        if playbackSpeed == 1.0 {
            playbackSpeed = 1.5
        } else if playbackSpeed == 1.5 {
            playbackSpeed = 2.0
        } else {
            playbackSpeed = 1.0
        }
    }

    private func toggleAudio() {
        RiseHaptic.impact(.medium)
        isPlaying.toggle()
        if isPlaying {
            RiseAudioEngine.shared.startSoundscape(.forestDawn)
            startAudioTimer()
        } else {
            RiseAudioEngine.shared.stopSoundscape()
            stopAudioTimer()
        }
    }

    private func startAudioTimer() {
        stopAudioTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            Task { @MainActor in
                let step = (0.25 * playbackSpeed) / 165.0
                if progress + step >= 1.0 {
                    progress = 0
                    isPlaying = false
                    RiseAudioEngine.shared.stopSoundscape()
                    stopAudioTimer()
                } else {
                    progress += step
                }
            }
        }
    }

    private func stopAudioTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview { MorningBoostView() }
