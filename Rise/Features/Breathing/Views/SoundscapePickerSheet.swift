//
//  SoundscapePickerSheet.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import SwiftUI

/// Modern modal sheet allowing users to select and customize ambient soundscapes.
public struct SoundscapePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var audioEngine = RiseAudioEngine.shared

    public init() {}

    public var body: some View {
        ZStack {
            RiseColors.backgroundAmbient.ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ambient Soundscapes")
                            .font(RiseTypography.titleSmallBold)
                            .foregroundStyle(RiseColors.textPrimary)
                        Text("Procedural sound & calming frequencies")
                            .font(RiseTypography.footnote)
                            .foregroundStyle(RiseColors.textSecondary)
                    }

                    Spacer()

                    RiseIconButton(
                        iconName: "xmark",
                        accessibilityLabel: "Close",
                        style: .glass,
                        size: 36
                    ) {
                        dismiss()
                    }
                }
                .padding(.top, 8)

                // Volume slider
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "speaker.wave.1.fill")
                            .font(RiseTypography.footnoteSemibold)
                            .foregroundStyle(RiseColors.textSecondary)
                        Text("Soundscape Volume")
                            .font(RiseTypography.footnoteSemibold)
                            .foregroundStyle(RiseColors.textSecondary)
                        Spacer()
                        Text("\(Int(audioEngine.volume * 100))%")
                            .font(RiseTypography.footnoteBold)
                            .foregroundStyle(RiseColors.accentPrimary)
                    }

                    Slider(
                        value: Binding(
                            get: { audioEngine.volume },
                            set: { audioEngine.volume = $0 }
                        ),
                        in: 0.0 ... 1.0
                    )
                    .tint(RiseColors.accentPrimary)
                }
                .padding(14)
                .riseRichGlass(cornerRadius: RiseRadius.large)

                // Soundscape list
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(SoundscapeType.allCases) { soundscape in
                            let isSelected = audioEngine.activeSoundscape == soundscape

                            Button {
                                RiseHaptic.selection()
                                if isSelected && audioEngine.isPlaying {
                                    audioEngine.stopSoundscape()
                                } else {
                                    audioEngine.startSoundscape(soundscape)
                                }
                            } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                isSelected
                                                    ? RiseColors.accentPrimary
                                                    : RiseColors.surfaceControl.opacity(0.85)
                                            )
                                            .frame(width: 44, height: 44)

                                        Image(systemName: soundscape.systemIcon)
                                            .font(RiseTypography.headline)
                                            .foregroundStyle(
                                                isSelected ? Color.white : RiseColors.accentPrimary
                                            )
                                    }

                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(soundscape.title)
                                            .font(RiseTypography.subheadlineBold)
                                            .foregroundStyle(RiseColors.textPrimary)

                                        Text(soundscape.subtitle)
                                            .font(RiseTypography.caption)
                                            .foregroundStyle(RiseColors.textSecondary)
                                    }

                                    Spacer()

                                    if isSelected {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(RiseTypography.titleSmall)
                                            .foregroundStyle(RiseColors.accentPrimary)
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(
                                            isSelected
                                                ? RiseColors.accentPrimary.opacity(0.16)
                                                : RiseColors.surfaceField.opacity(0.65)
                                        )
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(
                                            isSelected
                                                ? RiseColors.accentPrimary.opacity(0.75)
                                                : RiseColors.borderSoft,
                                            lineWidth: 1
                                        )
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 20)
                }

                RisePrimaryButton(
                    "Apply Soundscape",
                    iconName: "checkmark",
                    style: .gold
                ) {
                    RiseHaptic.notification(.success)
                    dismiss()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .presentationDetents([.fraction(0.78), .large])
        .presentationDragIndicator(.visible)
    }
}
