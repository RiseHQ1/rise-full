//
//  RisePackDetailView.swift
//  Rise
//
//  7-Day Guided Curriculum Experience & Audio Session Player View
//  Follows Blueprint Section 5 & 24 (Hero Artwork, 7-Day Sessions, Audio Streaming)
//

import SwiftUI

public struct RisePackDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var appRouter

    public let packTitle: String
    public let packCategory: String
    public let durationDays: Int
    public let isPro: Bool
    public let artworkAsset: String

    public struct PackSession: Identifiable {
        public let id: Int
        public let dayNumber: Int
        public let title: String
        public let description: String
        public let durationString: String
        public let isAudio: Bool
        public var isCompleted: Bool
    }

    @State private var sessions: [PackSession] = [
        PackSession(id: 1, dayNumber: 1, title: "Awakening with Intention", description: "You do not wake up to react; you wake up to create your day with quiet poise.", durationString: "4 min", isAudio: true, isCompleted: true),
        PackSession(id: 2, dayNumber: 2, title: "Release the Autopilot Rush", description: "Learn the somatic micro-pause between stimulation and your deliberate reaction.", durationString: "5 min", isAudio: true, isCompleted: false),
        PackSession(id: 3, dayNumber: 3, title: "Dichotomy of Control", description: "Categorize today's obstacles into what is within your power vs. what must be accepted.", durationString: "6 min", isAudio: true, isCompleted: false),
        PackSession(id: 4, dayNumber: 4, title: "Overcoming Friction & Resistance", description: "Embrace the initial 5 minutes of discomfort as proof of neuroplastic growth.", durationString: "5 min", isAudio: true, isCompleted: false),
        PackSession(id: 5, dayNumber: 5, title: "Unshakeable Stillness", description: "Guided 528Hz harmonic breathing to anchor your nervous system in calm certainty.", durationString: "7 min", isAudio: true, isCompleted: false),
        PackSession(id: 6, dayNumber: 6, title: "Courage in the Arena", description: "Step boldly into high-stakes conversations with grounded clarity and confidence.", durationString: "6 min", isAudio: true, isCompleted: false),
        PackSession(id: 7, dayNumber: 7, title: "The Sovereign Mind", description: "Consolidate your 7-day routine into an enduring lifetime habit ritual.", durationString: "8 min", isAudio: true, isCompleted: false),
    ]

    @State private var activePlayingSessionId: Int? = nil
    @State private var isPlaying = false
    @State private var showPaywall = false

    public init(
        packTitle: String = "Morning Reset",
        packCategory: String = "Morning",
        durationDays: Int = 7,
        isPro: Bool = false,
        artworkAsset: String = "pack_morning_reset"
    ) {
        self.packTitle = packTitle
        self.packCategory = packCategory
        self.durationDays = durationDays
        self.isPro = isPro
        self.artworkAsset = artworkAsset
    }

    public var body: some View {
        ZStack {
            RiseScreenBackground(imageMaxHeight: 320, bottomScrimOpacity: 0.98)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: RiseSpacing.md) {
                    // Top Chrome
                    RiseFeatureChrome(title: nil, onBack: { dismiss() }) {
                        RiseIconButton(
                            iconName: "square.and.arrow.up",
                            accessibilityLabel: "Share",
                            style: .glass,
                            size: RiseIconButtonMetrics.standard,
                            action: {}
                        )
                    }

                    // Pack Header Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(packCategory.uppercased())
                                .font(RiseTypography.captionBold)
                                .foregroundStyle(RiseColors.gold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(RiseColors.gold.opacity(0.12))
                                .clipShape(Capsule())

                            Spacer()

                            Text(isPro ? "PRO PACK" : "FREE PACK")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(isPro ? RiseColors.gold : RiseColors.emerald)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(isPro ? RiseColors.gold.opacity(0.1) : RiseColors.emerald.opacity(0.1))
                                .clipShape(Capsule())
                        }

                        Text(packTitle)
                            .font(RiseTypography.largeTitleBold)
                            .foregroundStyle(RiseColors.textPrimary)

                        Text("A 7-day progressive audio experience designed to rewire your morning routine, sharpen focus, and establish unshakeable daily consistency.")
                            .font(RiseTypography.body)
                            .foregroundStyle(RiseColors.textSecondary)

                        // Progress Bar
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Curriculum Progress")
                                    .font(RiseTypography.captionBold)
                                    .foregroundStyle(RiseColors.textSecondary)
                                Spacer()
                                Text("1 of 7 Completed")
                                    .font(RiseTypography.caption)
                                    .foregroundStyle(RiseColors.gold)
                            }

                            GeometryReader { g in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(RiseColors.surfacePrimary)
                                        .frame(height: 6)
                                    Capsule()
                                        .fill(RiseColors.gold)
                                        .frame(width: g.size.width * (1.0 / 7.0), height: 6)
                                }
                            }
                            .frame(height: 6)
                        }
                        .padding(.top, 4)
                    }
                    .padding(18)
                    .riseRichGlass(cornerRadius: RiseRadius.card)

                    // Sessions Header
                    HStack {
                        Text("7-Day Curriculum")
                            .font(RiseTypography.headlineBold)
                            .foregroundStyle(RiseColors.textPrimary)
                        Spacer()
                        Text("56 Total Minutes")
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textSecondary)
                    }
                    .padding(.horizontal, 4)

                    // Sessions List
                    VStack(spacing: 10) {
                        ForEach(sessions) { session in
                            sessionCard(session: session)
                        }
                    }

                    // Bottom Start Action
                    VStack(spacing: 8) {
                        RisePrimaryButton(
                            isPro ? "Unlock Full Pack · $2.99" : "Continue Day 2 Audio Session",
                            iconName: isPro ? "lock.open.fill" : "play.fill",
                            style: .gold
                        ) {
                            if isPro {
                                showPaywall = true
                            } else {
                                togglePlaySession(sessionId: 2)
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, RiseSpacing.md)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showPaywall) {
            RisePaywallView()
        }
    }

    // MARK: - Components

    private func sessionCard(session: PackSession) -> some View {
        let isCurrentPlaying = activePlayingSessionId == session.id && isPlaying

        return HStack(spacing: 14) {
            // Day Badge
            ZStack {
                Circle()
                    .fill(session.isCompleted ? RiseColors.gold : RiseColors.surfacePrimary)
                    .frame(width: 36, height: 36)
                if session.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(RiseColors.backgroundPrimary)
                } else {
                    Text("D\(session.dayNumber)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(RiseColors.textPrimary)
                }
            }

            // Session Meta
            VStack(alignment: .leading, spacing: 3) {
                Text("Day \(session.dayNumber): \(session.title)")
                    .font(RiseTypography.bodyBold)
                    .foregroundStyle(RiseColors.textPrimary)
                    .lineLimit(1)

                Text(session.description)
                    .font(RiseTypography.caption)
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Label(session.durationString, systemImage: "clock")
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(RiseColors.gold)

                    if session.isAudio {
                        Text("· 🎧 Guided Audio")
                            .font(.system(size: 10.5, weight: .medium))
                            .foregroundStyle(RiseColors.textSecondary)
                    }
                }
                .padding(.top, 2)
            }

            Spacer()

            // Play / Pause Circle
            Button {
                togglePlaySession(sessionId: session.id)
            } label: {
                ZStack {
                    Circle()
                        .fill(isCurrentPlaying ? RiseColors.gold : RiseColors.surfaceControl)
                        .frame(width: 38, height: 38)
                    Image(systemName: isCurrentPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(isCurrentPlaying ? RiseColors.backgroundPrimary : RiseColors.textPrimary)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(isCurrentPlaying ? RiseColors.gold.opacity(0.08) : RiseColors.surfacePrimary.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: RiseRadius.card))
        .overlay(
            RoundedRectangle(cornerRadius: RiseRadius.card)
                .stroke(isCurrentPlaying ? RiseColors.gold : RiseColors.borderSubtle, lineWidth: 1)
        )
    }

    private func togglePlaySession(sessionId: Int) {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        if activePlayingSessionId == sessionId {
            isPlaying.toggle()
        } else {
            activePlayingSessionId = sessionId
            isPlaying = true
        }
    }
}

#Preview {
    RisePackDetailView()
        .environment(AppRouter())
}
