//
//  SoundscapesModalView.swift
//  Rise
//
//  Created by Rise Team on 27/08/2026.
//

import SwiftUI

/// Premium Ambient Soundscapes Modal allowing users to play continuous soothing sounds (Rain, Ocean, Forest, Campfire, Alpha Waves)
/// with background playback and an integrated sleep timer.
public struct SoundscapesModalView: View {
    @Environment(\.dismiss) private var dismiss
    private var audioEngine = RiseAudioEngine.shared

    @State private var selectedTimer: Int? = RiseAudioEngine.shared.sleepTimerMinutes
    @State private var volume: Float = RiseAudioEngine.shared.volume

    private let availableSoundscapes: [SoundscapeType] = [
        .pinkRain,
        .brownHush,
        .forestDawn,
        .campfire,
        .binauralAlpha,
        .zenBell,
        .solfeggio528,
    ]

    private let timerOptions: [Int?] = [nil, 15, 30, 45, 60]

    public init() {}

    public var body: some View {
        ZStack {
            RiseColors.backgroundPrimary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Drag Handle
                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 36, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 16)

                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Image(systemName: "waveform.badge.magnifyingglass")
                                .font(RiseTypography.titleSmall)
                                .foregroundStyle(RiseColors.accentGold)

                            Text("Ambient Soundscapes")
                                .font(RiseTypography.title)
                                .foregroundStyle(RiseColors.textPrimary)
                        }

                        Text("Continuous soothing audio for focus, relaxation & sleep")
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textSecondary)
                    }

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(RiseTypography.title)
                            .foregroundStyle(RiseColors.textSecondary.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, RiseSpacing.lg)
                .padding(.bottom, 16)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // MARK: - Active Visualizer & Master Play/Stop Card

                        activePlayerBanner

                        // MARK: - Soundscape Selection Grid

                        VStack(alignment: .leading, spacing: 10) {
                            Text("CHOOSE SOUND")
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(RiseColors.textMuted)
                                .padding(.horizontal, 4)

                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                                ForEach(availableSoundscapes) { soundscape in
                                    soundscapeCard(soundscape)
                                }
                            }
                        }

                        // MARK: - Sleep Timer Section

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("SLEEP TIMER")
                                    .font(RiseTypography.microSemibold)
                                    .foregroundStyle(RiseColors.textMuted)

                                Spacer()

                                if audioEngine.isPlaying, let remaining = audioEngine.sleepTimerMinutes, audioEngine.sleepTimerRemainingSeconds > 0 {
                                    Text("Fades in \(audioEngine.sleepTimerRemainingSeconds / 60)m \(audioEngine.sleepTimerRemainingSeconds % 60)s")
                                        .font(RiseTypography.captionSemibold)
                                        .foregroundStyle(RiseColors.accentGold)
                                }
                            }
                            .padding(.horizontal, 4)

                            HStack(spacing: 8) {
                                ForEach(timerOptions, id: \.self) { minutes in
                                    let isSelected = selectedTimer == minutes
                                    Button {
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                        selectedTimer = minutes
                                        audioEngine.setSleepTimer(minutes: minutes)
                                    } label: {
                                        Text(minutes == nil ? "Off" : "\(minutes!)m")
                                            .font(RiseTypography.captionSemibold)
                                            .foregroundStyle(isSelected ? .black : RiseColors.textSecondary)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 38)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(isSelected ? RiseColors.accentGold : RiseColors.surfaceField.opacity(0.85))
                                            )
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(isSelected ? Color.clear : RiseColors.borderHairline, lineWidth: 1)
                                            }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        // MARK: - Volume Slider

                        VStack(alignment: .leading, spacing: 8) {
                            Text("VOLUME")
                                .font(RiseTypography.microSemibold)
                                .foregroundStyle(RiseColors.textMuted)
                                .padding(.horizontal, 4)

                            HStack(spacing: 12) {
                                Image(systemName: "speaker.fill")
                                    .font(RiseTypography.caption)
                                    .foregroundStyle(RiseColors.textMuted)

                                Slider(
                                    value: Binding(
                                        get: { volume },
                                        set: {
                                            volume = $0
                                            audioEngine.volume = $0
                                        }
                                    ),
                                    in: 0.0 ... 1.0
                                )
                                .tint(RiseColors.accentGold)

                                Image(systemName: "speaker.wave.3.fill")
                                    .font(RiseTypography.caption)
                                    .foregroundStyle(RiseColors.textMuted)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(RiseColors.surfaceField.opacity(0.85))
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(RiseColors.borderHairline, lineWidth: 1)
                            }
                        }

                        Color.clear.frame(height: 20)
                    }
                    .padding(.horizontal, RiseSpacing.lg)
                }
            }
        }
    }

    // MARK: - Active Player Banner

    private var activePlayerBanner: some View {
        HStack(spacing: 16) {
            // Animated Soundwave Visualizer
            HStack(spacing: 4) {
                visualizerBar(height: 18)
                visualizerBar(height: 28)
                visualizerBar(height: 22)
                visualizerBar(height: 14)
            }
            .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(audioEngine.isPlaying ? audioEngine.activeSoundscape.title : "Playback Paused")
                    .font(RiseTypography.headline)
                    .foregroundStyle(RiseColors.textPrimary)

                Text(audioEngine.isPlaying ? "Playing continuously • Background audio active" : "Select a soundscape below to begin")
                    .font(RiseTypography.caption)
                    .foregroundStyle(audioEngine.isPlaying ? RiseColors.accentGold : RiseColors.textSecondary)
            }

            Spacer()

            // Play / Pause Master Button
            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                if audioEngine.isPlaying {
                    audioEngine.stopSoundscape()
                } else {
                    audioEngine.startSoundscape(audioEngine.activeSoundscape)
                }
            } label: {
                Image(systemName: audioEngine.isPlaying ? "pause.fill" : "play.fill")
                    .font(RiseTypography.calloutSemibold)
                    .foregroundStyle(.black)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(RiseColors.accentGold)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(RiseColors.surfaceField.opacity(0.95))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(audioEngine.isPlaying ? RiseColors.accentGold.opacity(0.45) : RiseColors.borderHairline, lineWidth: 1.2)
        }
    }

    private func visualizerBar(height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(audioEngine.isPlaying ? RiseColors.accentGold : RiseColors.textMuted.opacity(0.4))
            .animation(
                audioEngine.isPlaying ? .easeInOut(duration: 0.45).repeatForever() : .default,
                value: audioEngine.isPlaying
            )
            .frame(width: 4, height: audioEngine.isPlaying ? height : 8)
    }

    // MARK: - Individual Soundscape Card

    private func soundscapeCard(_ soundscape: SoundscapeType) -> some View {
        let isActive = audioEngine.isPlaying && audioEngine.activeSoundscape == soundscape

        return Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            audioEngine.toggleSoundscape(soundscape)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(isActive ? RiseColors.accentGold.opacity(0.2) : Color.white.opacity(0.08))
                            .frame(width: 38, height: 38)

                        Image(systemName: soundscape.systemIcon)
                            .font(RiseTypography.calloutSemibold)
                            .foregroundStyle(isActive ? RiseColors.accentGold : .white)
                    }

                    Spacer()

                    if isActive {
                        Image(systemName: "checkmark.circle.fill")
                            .font(RiseTypography.subheadlineSemibold)
                            .foregroundStyle(RiseColors.accentGold)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(soundscape.title)
                        .font(RiseTypography.subheadlineSemibold)
                        .foregroundStyle(RiseColors.textPrimary)

                    Text(soundscape.subtitle)
                        .font(RiseTypography.micro)
                        .foregroundStyle(RiseColors.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 125)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(RiseColors.surfaceField.opacity(isActive ? 0.95 : 0.75))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isActive ? RiseColors.accentGold : RiseColors.borderHairline, lineWidth: isActive ? 1.5 : 1)
            }
        }
        .buttonStyle(.plain)
    }
}
