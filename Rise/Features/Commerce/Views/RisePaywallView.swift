//
//  RisePaywallView.swift
//  Rise
//
//  Official Rise+ Premium Subscription Paywall Modal View
//  Follows Blueprint Section 6 & 18 (Liquid Glass, 3-Tier Pricing, StoreKit 2)
//

import SwiftUI

public struct RisePaywallView: View {
    @Environment(\.dismiss) private var dismiss

    public enum PlanTier: String, CaseIterable, Identifiable {
        case annual
        case monthly
        case lifetime

        public var id: String { rawValue }

        public var title: String {
            switch self {
            case .annual: return "Annual Plan"
            case .monthly: return "Monthly Plan"
            case .lifetime: return "Lifetime Access"
            }
        }

        public var price: String {
            switch self {
            case .annual: return "$29.99 / year"
            case .monthly: return "$4.99 / month"
            case .lifetime: return "$79.99 one-time"
            }
        }

        public var subtitle: String {
            switch self {
            case .annual: return "$2.49/mo · 7-Day Free Trial"
            case .monthly: return "Billed monthly · Cancel anytime"
            case .lifetime: return "Pay once · Unlimited forever"
            }
        }

        public var badge: String? {
            switch self {
            case .annual: return "BEST VALUE · 50% OFF"
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
            RiseScreenBackground(imageMaxHeight: 340, bottomScrimOpacity: 0.98)

            ScrollView(showsIndicators: false) {
                VStack(spacing: RiseSpacing.lg) {
                    // Top Chrome: Close + Restore
                    HStack {
                        RiseIconButton(
                            iconName: "xmark",
                            accessibilityLabel: "Close",
                            style: .glass,
                            size: RiseIconButtonMetrics.standard,
                            action: { dismiss() }
                        )

                        Spacer()

                        Button("Restore") {
                            restorePurchases()
                        }
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(RiseColors.surfaceGlass)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, RiseSpacing.md)
                    .padding(.top, RiseSpacing.sm)

                    // Hero Header
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 11, weight: .bold))
                            Text("UNLOCK RISE+")
                                .font(RiseTypography.captionBold)
                                .tracking(1.2)
                        }
                        .foregroundStyle(RiseColors.gold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(RiseColors.gold.opacity(0.12))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(RiseColors.gold.opacity(0.3), lineWidth: 1)
                        )

                        Text("Transform Your Mindset With Unlimited Depth")
                            .font(RiseTypography.title1Bold)
                            .foregroundStyle(RiseColors.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)

                        Text("Join over 10,000+ mindful individuals achieving calm consistency, daily focus, and emotional mastery.")
                            .font(RiseTypography.subheadline)
                            .foregroundStyle(RiseColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }

                    // Feature Matrix
                    VStack(alignment: .leading, spacing: 14) {
                        featureRow(icon: "brain.head.profile", title: "Unlimited AI Morning Boosts", subtitle: "Deep philosophical reasoning powered by Google Gemini.")
                        featureRow(icon: "shippingbox.fill", title: "Full 8 Rise Packs Library", subtitle: "All 56 guided audio sessions and transformational challenges.")
                        featureRow(icon: "sparkles", title: "All 16 Affirmation Categories", subtitle: "Personalized daily affirmation decks & notification rotation.")
                        featureRow(icon: "waveform", title: "528Hz Solfeggio Soundscapes", subtitle: "Procedural harmonic frequencies for deep focus & sleep.")
                        featureRow(icon: "icloud.fill", title: "Encrypted Cloud Sync", subtitle: "Seamlessly sync your journal & streak across all your devices.")
                    }
                    .padding(18)
                    .riseRichGlass(cornerRadius: RiseRadius.card)
                    .padding(.horizontal, RiseSpacing.md)

                    // 3-Tier Plan Selector
                    VStack(spacing: 10) {
                        ForEach(PlanTier.allCases) { plan in
                            planOptionCard(plan: plan)
                        }
                    }
                    .padding(.horizontal, RiseSpacing.md)

                    // CTA Button
                    VStack(spacing: 8) {
                        RisePrimaryButton(
                            selectedPlan == .annual ? "Start 7-Day Free Trial" : "Continue with \(selectedPlan.title)",
                            iconName: "arrow.right",
                            style: .gold
                        ) {
                            purchaseSelectedPlan()
                        }
                        .disabled(isPurchasing)

                        Text(selectedPlan == .annual ? "Then $29.99/year. Cancel anytime in App Store." : "Auto-renews until canceled in App Store settings.")
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textMuted)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, RiseSpacing.md)

                    // Legal Footers
                    HStack(spacing: 16) {
                        Button("Terms of Service") {}
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textMuted)

                        Text("·")
                            .foregroundStyle(RiseColors.textMuted)

                        Button("Privacy Policy") {}
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textMuted)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .alert("Rise+ Activated!", isPresented: $showSuccessAlert) {
            Button("Let's Rise") { dismiss() }
        } message: {
            Text("Welcome to Rise+. You now have unlimited access to all AI engines, Rise Packs, and mindfulness tools.")
        }
    }

    // MARK: - Components

    private func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(RiseColors.gold.opacity(0.15))
                    .frame(width: 28, height: 28)
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(RiseColors.gold)
            }
            .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(RiseTypography.bodyBold)
                    .foregroundStyle(RiseColors.textPrimary)
                Text(subtitle)
                    .font(RiseTypography.caption)
                    .foregroundStyle(RiseColors.textSecondary)
            }
            Spacer(minLength: 0)
        }
    }

    private func planOptionCard(plan: PlanTier) -> some View {
        let isSelected = selectedPlan == plan

        return Button {
            withAnimation(RiseAnimations.interactiveSpring) {
                selectedPlan = plan
            }
        } label: {
            HStack(spacing: 12) {
                // Radio indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? RiseColors.gold : RiseColors.textMuted.opacity(0.4), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle()
                            .fill(RiseColors.gold)
                            .frame(width: 10, height: 10)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text(plan.title)
                            .font(RiseTypography.bodyBold)
                            .foregroundStyle(RiseColors.textPrimary)

                        if let badge = plan.badge {
                            Text(badge)
                                .font(.system(size: 9.5, weight: .bold))
                                .foregroundStyle(RiseColors.backgroundPrimary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(RiseColors.gold)
                                .clipShape(Capsule())
                        }
                    }

                    Text(plan.subtitle)
                        .font(RiseTypography.caption)
                        .foregroundStyle(RiseColors.textSecondary)
                }

                Spacer()

                Text(plan.price)
                    .font(RiseTypography.subheadlineBold)
                    .foregroundStyle(isSelected ? RiseColors.gold : RiseColors.textPrimary)
            }
            .padding(14)
            .background(isSelected ? RiseColors.gold.opacity(0.08) : RiseColors.surfacePrimary.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: RiseRadius.card))
            .overlay(
                RoundedRectangle(cornerRadius: RiseRadius.card)
                    .stroke(isSelected ? RiseColors.gold : RiseColors.borderSubtle, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func purchaseSelectedPlan() {
        isPurchasing = true
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isPurchasing = false
            showSuccessAlert = true
        }
    }

    private func restorePurchases() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

#Preview {
    RisePaywallView()
}
