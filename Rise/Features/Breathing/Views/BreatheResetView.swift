//
//  BreatheResetView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Box-breathing session screen matching the Breathe & Reset mockup.
public struct BreatheResetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .largeTitle) private var breathTimerSize: CGFloat = 64

    @State private var isRunning = false
    @State private var isMuted = false
    @State private var phaseIndex = 0
    @State private var roundIndex = 0
    @State private var secondsLeft = 4
    @State private var phaseProgress: CGFloat = 0
    @State private var timer: Timer?
    @State private var showSoundscapeSheet = false
    @State private var savePulse = 0

    private var phases: [BreathPhase] {
        [
            .init(title: RiseL10n.tr("breathing.inhale"), prompt: RiseL10n.tr("breathing.inhalePrompt"), icon: "wind", accent: .purple, seconds: 4),
            .init(title: RiseL10n.tr("breathing.hold"), prompt: RiseL10n.tr("breathing.holdPrompt"), icon: "pause.circle", accent: .muted, seconds: 4),
            .init(title: RiseL10n.tr("breathing.exhale"), prompt: RiseL10n.tr("breathing.exhalePrompt"), icon: "wind", accent: .gold, seconds: 4),
            .init(title: RiseL10n.tr("breathing.hold"), prompt: RiseL10n.tr("breathing.holdPrompt"), icon: "pause.circle", accent: .muted, seconds: 4),
        ]
    }

    private let totalRounds = 4
    private let ringSize: CGFloat = 220
    private let ringLineWidth: CGFloat = 3.5

    public init() {}

    public var body: some View {
        ZStack {
            backgroundLayer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    RiseFeatureChrome(
                        title: RiseL10n.tr("breathing.title"),
                        onBack: { dismiss() },
                        trailing: {
                            RiseIconButton(
                                iconName: SavedContentStore.shared.isSaved(title: "Box Breathing Reset") ? "bookmark.fill" : "bookmark",
                                accessibilityLabel: "Bookmark",
                                style: .glass,
                                size: RiseIconButtonMetrics.standard,
                                bounceTrigger: savePulse,
                                action: {
                                    SavedContentStore.shared.toggleSave(
                                        title: "Box Breathing Reset",
                                        subtitle: "2-minute box breathing session",
                                        category: "Breathwork",
                                        assetName: "onboarding_focus_bg"
                                    )
                                    savePulse += 1
                                }
                            )
                        }
                    )

                    heroHeader
                    breathingCard
                    beforeYouBeginCard
                    controlsDock
                    footerNote
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.bottom, 28)
            }
        }
        .navigationBarHidden(true)
        .onDisappear {
            stopTimer()
            RiseAudioEngine.shared.stopSoundscape()
        }
        .sheet(isPresented: $showSoundscapeSheet) {
            SoundscapePickerSheet()
        }
    }

    // MARK: - Background

    private var backgroundLayer: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                RiseColors.backgroundAmbient

                Image("onboarding_welcome_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height * 0.52, alignment: .top)
                    .clipped()
                    .overlay {
                        LinearGradient(
                            stops: [
                                .init(color: Color.black.opacity(0.18), location: 0),
                                .init(color: Color.clear, location: 0.35),
                                .init(color: RiseColors.backgroundAmbient.opacity(0.55), location: 0.72),
                                .init(color: RiseColors.backgroundAmbient, location: 1),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }

                VStack {
                    Spacer()
                    LinearGradient(
                        colors: [
                            RiseColors.backgroundAmbient.opacity(0),
                            RiseColors.backgroundAmbient.opacity(0.92),
                            RiseColors.backgroundAmbient,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.42)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .ignoresSafeArea()
    }

    // MARK: - Hero

    private var heroHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Take a deep breath.")
                .font(RiseTypography.title)
                .foregroundStyle(RiseColors.textPrimary)

            HStack(spacing: 6) {
                Text("You've got this.")
                    .font(RiseTypography.title)
                    .foregroundStyle(RiseColors.textPrimary)
                Image(systemName: "heart.fill")
                    .font(RiseTypography.calloutBold)
                    .foregroundStyle(RiseColors.accentPrimary)
                Image(systemName: "heart.fill")
                    .font(RiseTypography.microBold)
                    .foregroundStyle(RiseColors.accentPrimary.opacity(0.75))
                    .offset(x: -4, y: 2)
            }

            HStack(spacing: 8) {
                heroBadge(icon: "leaf.fill", title: RiseL10n.tr("breathing.tagline"))
                heroBadge(icon: "clock", title: RiseL10n.tr("breathing.duration"))
                Button {
                    RiseHaptic.impact(.light)
                    showSoundscapeSheet = true
                } label: {
                    heroBadge(
                        icon: RiseAudioEngine.shared.activeSoundscape.systemIcon,
                        title: RiseAudioEngine.shared.activeSoundscape.title
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }

    private func heroBadge(icon: String, title: String) -> some View {
        RiseTag(title, iconName: icon, isSelected: false) {}
    }

    // MARK: - Breathing card

    private var breathingCard: some View {
        VStack(spacing: 18) {
            ZStack(alignment: .topTrailing) {
                Text(RiseL10n.tr("breathing.followCircle"))
                    .font(RiseTypography.calloutSemibold)
                    .foregroundStyle(Color(hex: "#C4B5FD"))
                    .frame(maxWidth: .infinity)

                Button {
                    isMuted.toggle()
                } label: {
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(RiseTypography.calloutSemibold)
                        .foregroundStyle(Color(hex: "#C4B5FD"))
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(RiseColors.surfaceInset.opacity(0.8)))
                }
                .buttonStyle(.plain)
            }

            breathRing

            Text("\(min(roundIndex + 1, totalRounds)) of \(totalRounds)")
                .font(RiseTypography.caption)
                .foregroundStyle(Color(hex: "#C4B5FD"))
                .accessibilityLabel("Round \(min(roundIndex + 1, totalRounds)) of \(totalRounds)")

            phaseStepsRow
        }
        .padding(16)
        .riseRichGlass(cornerRadius: RiseRadius.extraLarge)
        .accessibilityElement(children: .contain)
    }

    /// Full clean ring with orb traveling around the path.
    private var breathRing: some View {
        let current = phases[phaseIndex]
        let radius = (ringSize - ringLineWidth) / 2

        return ZStack {
            // Full thin neon ring (always complete — progress is the orb)
            Circle()
                .stroke(
                    AngularGradient(
                        colors: ringGradientColors,
                        center: .center,
                        angle: .degrees(-90)
                    ),
                    style: StrokeStyle(lineWidth: ringLineWidth, lineCap: .round)
                )
                .frame(width: ringSize, height: ringSize)

            // Progress orb
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white,
                            Color(hex: "#E9D5FF"),
                            Color(hex: "#A855F7").opacity(0.8),
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 8
                    )
                )
                .frame(width: 14, height: 14)
                .offset(y: -radius)
                .rotationEffect(.degrees(reduceMotion ? 0 : 360 * Double(phaseProgress)))
                .accessibilityHidden(true)

            VStack(spacing: 2) {
                Text(current.prompt)
                    .font(RiseTypography.subheadline)
                    .foregroundStyle(Color(hex: "#C4B5FD"))
                    .id(current.prompt)
                    .transition(reduceMotion ? .identity : .opacity)
                Text("\(secondsLeft)")
                    // ScaledMetric keeps the large timer legible while respecting Dynamic Type.
                    .font(.system(size: breathTimerSize, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "#EDE4FF"))
                    .contentTransition(reduceMotion ? .identity : .numericText())
                    .accessibilityIdentifier(RiseAccessibilityID.breatheTimer)
                Text(RiseL10n.tr("breathing.seconds"))
                    .font(RiseTypography.caption)
                    .foregroundStyle(Color(hex: "#A78BFA"))
            }
            .scaleEffect(
                reduceMotion
                    ? 1.0
                    : (phaseIndex == 0 ? (1.0 + 0.07 * phaseProgress) : (phaseIndex == 2 ? (1.07 - 0.10 * phaseProgress) : 1.0))
            )
            .animation(RiseAnimations.preferred(.easeInOut(duration: 0.15), reduceMotion: reduceMotion), value: phaseProgress)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(current.prompt), \(secondsLeft) seconds remaining")
            .accessibilityValue(current.title)
            .accessibilityIdentifier(RiseAccessibilityID.breathePhase)
        }
        .frame(width: ringSize + 24, height: ringSize + 24)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .accessibilityAddTraits(.updatesFrequently)
    }

    private var ringGradientColors: [Color] {
        [
            Color(hex: "#7C3AED"),
            Color(hex: "#A855F7"),
            Color(hex: "#EC4899"),
            RiseColors.accentSecondary,
            Color(hex: "#FCD34D"),
            Color(hex: "#A855F7"),
            Color(hex: "#7C3AED"),
        ]
    }

    private var phaseStepsRow: some View {
        HStack(spacing: 0) {
            ForEach(Array(phases.enumerated()), id: \.offset) { index, phase in
                phaseStepChip(phase, isActive: index == phaseIndex)

                if index < phases.count - 1 {
                    dashedConnector
                }
            }
        }
        .animation(RiseAnimations.preferred(RiseAnimations.riseSettle, reduceMotion: reduceMotion), value: phaseIndex)
    }

    private var dashedConnector: some View {
        Canvas { context, size in
            var path = Path()
            path.move(to: CGPoint(x: 2, y: size.height / 2))
            path.addLine(to: CGPoint(x: size.width - 2, y: size.height / 2))
            context.stroke(
                path,
                with: .color(Color.white.opacity(0.28)),
                style: StrokeStyle(lineWidth: 1.2, dash: [3, 4])
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 12)
    }

    private func phaseStepChip(_ phase: BreathPhase, isActive: Bool) -> some View {
        let color = chipColor(for: phase, isActive: isActive)
        return VStack(spacing: 3) {
            Image(systemName: phase.icon)
                .font(RiseTypography.footnoteBold)
                .foregroundStyle(color)
            Text("\(phase.seconds)")
                .font(RiseTypography.headlineBold)
                .foregroundStyle(color)
            Text(phase.title)
                .font(RiseTypography.microSemibold)
                .foregroundStyle(isActive ? RiseColors.textPrimary : RiseColors.textMuted)
        }
        .frame(width: 68, height: 72)
        .background(
            RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                .fill(RiseColors.surfaceField.opacity(0.92))
        )
        .overlay {
            RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                .stroke(
                    isActive ? RiseColors.accentPrimary : RiseColors.borderSoft,
                    lineWidth: isActive ? 1.5 : 1
                )
        }
        .shadow(
            color: isActive ? RiseColors.accentPrimary.opacity(0.28) : .clear,
            radius: isActive ? 10 : 0
        )
        .scaleEffect(isActive ? 1.05 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(phase.title), \(phase.seconds) seconds")
        .accessibilityAddTraits(isActive ? [.isSelected] : [])
    }

    private func chipColor(for phase: BreathPhase, isActive: Bool) -> Color {
        if isActive {
            return RiseColors.accentPrimary
        }
        switch phase.accent {
        case .gold: return RiseColors.accentSecondary
        case .purple: return RiseColors.accentPrimary.opacity(0.65)
        case .muted: return RiseColors.textMuted
        }
    }

    // MARK: - Before you begin

    private var beforeYouBeginCard: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .font(RiseTypography.captionSemibold)
                        .foregroundStyle(RiseColors.accentPrimary)
                    Text("Before you begin")
                        .font(RiseTypography.calloutBold)
                        .foregroundStyle(RiseColors.accentPrimary)
                }
                Text("Find a comfortable position. Let's take 2 minutes just for you.")
                    .font(RiseTypography.footnote)
                    .foregroundStyle(RiseColors.textPrimary.opacity(0.92))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Image("onboarding_icon_calm")
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(RiseColors.surfaceField.opacity(0.88))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(RiseColors.accentPrimary.opacity(0.45), lineWidth: 1)
        }
    }

    // MARK: - Controls dock

    private var controlsDock: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(RiseColors.backgroundAmbient.opacity(0.96))
                .overlay {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(RiseColors.borderSoft, lineWidth: 1)
                }
                .frame(height: 108)
                .padding(.top, 28)

            HStack(alignment: .bottom, spacing: 0) {
                controlSideButton(
                    systemIcon: "arrow.clockwise",
                    title: "Restart",
                    action: restart
                )

                Spacer()

                VStack(spacing: 8) {
                    RiseGoldCircleButton(
                        systemName: isRunning ? "pause.fill" : "play.fill",
                        size: 82,
                        iconSize: 28,
                        usesWarmGradient: true,
                        iconOffsetX: isRunning ? 0 : 2
                    ) {
                        togglePlayPause()
                    }

                    Text(isRunning ? "Pause" : "Start")
                        .font(RiseTypography.footnoteBold)
                        .foregroundStyle(RiseColors.textPrimary)
                }

                Spacer()

                controlSideButton(
                    systemIcon: "stop.fill",
                    title: "End session",
                    action: endSession
                )
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 14)
            .padding(.top, 4)
        }
        .padding(.top, 4)
    }

    private func controlSideButton(systemIcon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemIcon)
                    .font(RiseTypography.calloutSemibold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(RiseColors.surfaceControl.opacity(0.95)))
                    .overlay {
                        Circle().stroke(RiseColors.borderSoft, lineWidth: 1)
                    }

                Text(title)
                    .font(RiseTypography.captionSemibold)
                    .foregroundStyle(RiseColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 92)
        }
        .buttonStyle(.plain)
    }

    private var footerNote: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "clock")
                .font(RiseTypography.captionSemibold)
                .foregroundStyle(RiseColors.textMuted)
                .padding(.top, 2)
            Text("Great job showing up for yourself.\nConsistency creates change.")
                .font(RiseTypography.caption)
                .foregroundStyle(RiseColors.textMuted)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 2)
    }

    // MARK: - Session logic

    private func togglePlayPause() {
        if isRunning {
            pauseSession()
        } else {
            startSession()
        }
    }

    private func startSession() {
        isRunning = true
        stopTimer()
        if !isMuted, RiseAudioEngine.shared.activeSoundscape != .none {
            RiseAudioEngine.shared.startSoundscape(RiseAudioEngine.shared.activeSoundscape)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            Task { @MainActor in
                tick()
            }
        }
    }

    private func pauseSession() {
        isRunning = false
        stopTimer()
        RiseAudioEngine.shared.stopSoundscape()
    }

    private func restart() {
        stopTimer()
        RiseAudioEngine.shared.stopSoundscape()
        isRunning = false
        phaseIndex = 0
        roundIndex = 0
        secondsLeft = phases[0].seconds
        phaseProgress = 0
    }

    private func endSession() {
        stopTimer()
        RiseAudioEngine.shared.stopSoundscape()
        dismiss()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        let phase = phases[phaseIndex]
        let step = CGFloat(0.05 / Double(phase.seconds))
        phaseProgress = min(1, phaseProgress + step)

        let remaining = max(1, Int(ceil(Double(phase.seconds) * Double(1 - phaseProgress))))
        if remaining != secondsLeft {
            withAnimation(.easeInOut(duration: 0.15)) {
                secondsLeft = remaining
            }
        }

        if phaseProgress >= 1 {
            advancePhase()
        }
    }

    private func advancePhase() {
        phaseProgress = 0
        if phaseIndex == phases.count - 1 {
            roundIndex += 1
            if roundIndex >= totalRounds {
                isRunning = false
                stopTimer()
                secondsLeft = 0
                RiseHaptic.notification(.success)
                return
            }
            phaseIndex = 0
        } else {
            phaseIndex += 1
        }
        RiseHaptic.impact(.soft)
        if !isMuted {
            RiseAudioEngine.shared.playChime()
        }
        secondsLeft = phases[phaseIndex].seconds
    }
}

private struct BreathPhase: Identifiable, Hashable {
    enum Accent: Hashable {
        case purple
        case gold
        case muted
    }

    let title: String
    let prompt: String
    let icon: String
    let accent: Accent
    let seconds: Int

    var id: String {
        "\(title)-\(prompt)-\(accent)"
    }
}

#Preview { BreatheResetView() }
