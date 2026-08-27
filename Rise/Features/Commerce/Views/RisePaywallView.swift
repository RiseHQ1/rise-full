//
//  RisePaywallView.swift
//  Rise
//
//  Official Rise+ Premium Subscription Paywall Modal View
//  Faithfully styled to match the approved Sunrise Hero visual design with 3-tier commercial options
//

import SwiftUI

public struct RisePaywallView: View {
    @Environment(\.dismiss) private var dismiss

    public enum PlanTier: String, CaseIterable, Identifiable {
        case annual
        case monthly
        case lifetime

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .annual: return "Annual Plan"
            case .monthly: return "Monthly Plan"
            case .lifetime: return "Lifetime Access"
            }
        }

        public var priceString: String {
            switch self {
            case .annual: return "$29.99 / year"
            case .monthly: return "$4.99 / month"
            case .lifetime: return "$79.99"
            }
        }

        public var subpriceString: String {
            switch self {
            case .annual: return "$2.49/mo · 7-Day Free Trial"
            case .monthly: return "Billed monthly · Cancel anytime"
            case .lifetime: return "Pay once · Unlimited forever"
            }
        }

        public var discountBadge: String? {
            switch self {
            case .annual: return "Save 50%"
            case .monthly: return nil
            case .lifetime: return "ONE-TIME"
            }
        }
    }

    @State private var selectedPlan: PlanTier = .annual
    @State private var isPurchasing = false
    @State private var showSuccessAlert = false

    public init() {}

    public var body: some View {
        ZStack {
            // Dark Base Layer
            RiseColors.backgroundPrimary
                .ignoresSafeArea()

            // Scrollable Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Image & Header Stack
                    ZStack(alignment: .top) {
                        // Sunrise Hero Background
                        Image("splash_sunrise_scene")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 380)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    stops: [
                                        .init(color: Color.black.opacity(0.4), location: 0.0),
                                        .init(color: Color.clear, location: 0.3),
                                        .init(color: RiseColors.backgroundPrimary.opacity(0.88), location: 0.75),
                                        .init(color: RiseColors.backgroundPrimary, location: 1.0),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        // Top Bar: Centered RISE+ Brand & Dismiss Button
                        VStack(spacing: 0) {
                            HStack {
                                Spacer()

                                // Centered RISE+ Logo
                                HStack(spacing: 4) {
                                    Text("RISE")
                                        .font(.system(size: 20, weight: .black, design: .rounded))
                                        .foregroundStyle(RiseColors.textPrimary)
                                        .tracking(2)

                                    Image(systemName: "sparkle")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(RiseColors.gold)
                                }
                                .padding(.leading, 36) // Visual balance against close button

                                Spacer()

                                // Close Button
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(RiseColors.textPrimary)
                                        .frame(width: 36, height: 36)
                                        .background(Color.black.opacity(0.55))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Close")
                            }
                            .padding(.horizontal, RiseSpacing.md)
                            .padding(.top, 16)

                            Spacer()

                            // Editorial Headline & Subtitle
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Rise beyond\nyour limits.")
                                    .font(.system(size: 32, weight: .bold, design: .serif))
                                    .foregroundStyle(RiseColors.textPrimary)
                                    .lineSpacing(2)

                                Text("Unlock unlimited AI Stoic coaching, full audio packs, and daily mindfulness depth.")
                                    .font(RiseTypography.subheadline)
                                    .foregroundStyle(RiseColors.textSecondary)
                                    .lineSpacing(3)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, RiseSpacing.md)
                            .padding(.bottom, 16)
                        }
                        .frame(height: 380)
                    }

                    // Feature Matrix Card
                    VStack(spacing: 16) {
                        featureRow(
                            icon: "brain.head.profile",
                            title: "Unlimited AI Morning Boosts",
                            subtitle: "Deep Stoic cognitive reframing powered by Google Gemini"
                        )
                        featureRow(
                            icon: "shippingbox.fill",
                            title: "Full 8 Rise Packs Library",
                            subtitle: "56 guided audio sessions for Morning Reset, Focus & Calm"
                        )
                        featureRow(
                            icon: "sparkles",
                            title: "All 16 Affirmation Decks",
                            subtitle: "Personalized daily affirmation rotations for your focus areas"
                        )
                        featureRow(
                            icon: "waveform",
                            title: "528Hz Solfeggio Soundscapes",
                            subtitle: "Harmonic frequencies for deep focus, breathwork, and sleep"
                        )
                        featureRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Deep Habit & Streak Tracking",
                            subtitle: "Milestone badges, mood trends, and monthly growth insights"
                        )
                    }
                    .padding(18)
                    .background(Color(hex: "#121024").opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: RiseRadius.cardLarge))
                    .overlay(
                        RoundedRectangle(cornerRadius: RiseRadius.cardLarge)
                            .stroke(RiseColors.borderHairline, lineWidth: 1)
                    )
                    .padding(.horizontal, RiseSpacing.md)
                    .padding(.top, 4)

                    // Plan Selection Container (3-Tier)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 4) {
                            Text("SELECT MEMBERSHIP")
                                .font(RiseTypography.captionBold)
                                .foregroundStyle(RiseColors.gold)
                                .tracking(1.2)
                        }

                        // 1. Annual Option (Default & Best Value)
                        planRow(plan: .annual)

                        // 2. Monthly Option
                        planRow(plan: .monthly)

                        // 3. Lifetime Option
                        planRow(plan: .lifetime)
                    }
                    .padding(18)
                    .background(Color(hex: "#15122B").opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: RiseRadius.cardLarge))
                    .overlay(
                        RoundedRectangle(cornerRadius: RiseRadius.cardLarge)
                            .stroke(RiseColors.borderSubtle, lineWidth: 1)
                    )
                    .padding(.horizontal, RiseSpacing.md)
                    .padding(.top, 14)

                    // Primary Gold CTA Button
                    Button {
                        purchaseSelectedPlan()
                    } label: {
                        HStack {
                            Spacer()
                            Text(ctaButtonTitle)
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundStyle(RiseColors.textOnGold)
                            Spacer()
                        }
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#FDE68A"),
                                    Color(hex: "#F59E0B"),
                                    Color(hex: "#D97706"),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: RiseColors.gold.opacity(0.3), radius: 12, y: 4)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, RiseSpacing.md)
                    .padding(.top, 18)
                    .disabled(isPurchasing)

                    // Reassurance & Subtext
                    Text(reassuranceSubtext)
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textMuted)
                        .padding(.top, 10)

                    // Divider with "or"
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(RiseColors.borderHairline)
                            .frame(height: 1)
                        Text("or")
                            .font(RiseTypography.micro)
                            .foregroundStyle(RiseColors.textMuted)
                        Rectangle()
                            .fill(RiseColors.borderHairline)
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 48)
                    .padding(.vertical, 10)

                    // Restore Purchase
                    Button {
                        restorePurchases()
                    } label: {
                        Text("Restore Purchase")
                            .font(RiseTypography.captionBold)
                            .foregroundStyle(RiseColors.gold)
                    }
                    .buttonStyle(.plain)

                    // Legal Links
                    HStack(spacing: 16) {
                        Button("Terms of Service") {}
                            .font(RiseTypography.micro)
                            .foregroundStyle(RiseColors.textMuted)

                        Text("•")
                            .font(RiseTypography.micro)
                            .foregroundStyle(RiseColors.textMuted)

                        Button("Privacy Policy") {}
                            .font(RiseTypography.micro)
                            .foregroundStyle(RiseColors.textMuted)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 36)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .alert("RISE+ Activated!", isPresented: $showSuccessAlert) {
            Button("Let's Rise") { dismiss() }
        } message: {
            Text("Welcome to RISE+. You now have unlimited access to Google Gemini AI coaching, the full 8-Pack library, and harmonic soundscapes.")
        }
    }

    // MARK: - Dynamic Labels

    private var ctaButtonTitle: String {
        switch selectedPlan {
        case .annual: return "Start 7-Day Free Trial"
        case .monthly: return "Start RISE+ Monthly"
        case .lifetime: return "Unlock Lifetime Access"
        }
    }

    private var reassuranceSubtext: String {
        switch selectedPlan {
        case .annual: return "7 days free, then $29.99/year. Cancel anytime."
        case .monthly: return "Auto-renews monthly until canceled in App Store."
        case .lifetime: return "One-time payment of $79.99. No recurring fees."
        }
    }

    // MARK: - Subcomponents

    private func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(RiseColors.gold)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(RiseTypography.bodyEmphasized)
                    .foregroundStyle(RiseColors.textPrimary)
                Text(subtitle)
                    .font(RiseTypography.caption)
                    .foregroundStyle(RiseColors.textSecondary)
            }

            Spacer(minLength: 0)
        }
    }

    private func planRow(plan: PlanTier) -> some View {
        let isSelected = selectedPlan == plan

        return Button {
            withAnimation(RiseAnimations.interactiveSpring) {
                selectedPlan = plan
            }
        } label: {
            HStack(spacing: 12) {
                // Radio Circle
                ZStack {
                    Circle()
                        .stroke(isSelected ? RiseColors.gold : RiseColors.textMuted.opacity(0.4), lineWidth: 2)
                        .frame(width: 22, height: 22)

                    if isSelected {
                        Circle()
                            .fill(RiseColors.gold)
                            .frame(width: 14, height: 14)
                        Image(systemName: "checkmark")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(RiseColors.textOnGold)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(plan.title)
                        .font(RiseTypography.bodyEmphasized)
                        .foregroundStyle(RiseColors.textPrimary)

                    Text(plan.subpriceString)
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }

                Spacer()

                if let badge = plan.discountBadge {
                    Text(badge)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(RiseColors.textOnGold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(RiseColors.gold)
                        .clipShape(Capsule())
                }
            }
            .padding(14)
            .background(isSelected ? RiseColors.gold.opacity(0.06) : Color(hex: "#100C24"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? RiseColors.gold : RiseColors.borderHairline, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func purchaseSelectedPlan() {
        isPurchasing = true
        RiseHaptic.notification(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isPurchasing = false
            showSuccessAlert = true
        }
    }

    private func restorePurchases() {
        RiseHaptic.impact(.medium)
    }
}

#Preview {
    RisePaywallView()
}
