//
//  NotificationPreferencesView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Customize which Rise reminders and updates the user receives.
public struct NotificationPreferencesView: View {
    @State private var dailyMotivation = true
    @State private var eveningReflection = true
    @State private var intentionReminder = true
    @State private var streakUpdates = true
    @State private var weeklySummary = false

    public init() {}

    public var body: some View {
        ProfileSubscreenScaffold(
            title: "Notifications",
            subtitle: "Customize what you receive from Rise."
        ) {
            VStack(spacing: 10) {
                toggleRow(
                    asset: "onboarding_icon_sun",
                    title: "Daily motivation",
                    subtitle: "Get your morning boost.",
                    isOn: $dailyMotivation
                )
                toggleRow(
                    asset: "onboarding_icon_moon",
                    title: "Evening reflection",
                    subtitle: "A reminder to close your day.",
                    isOn: $eveningReflection
                )
                toggleRow(
                    asset: "onboarding_icon_target",
                    title: "Intention reminder",
                    subtitle: "A gentle nudge about your intention.",
                    isOn: $intentionReminder
                )
                toggleRow(
                    systemIcon: "flame.fill",
                    title: "Streak updates",
                    subtitle: "Celebrate consistency milestones.",
                    isOn: $streakUpdates
                )
                toggleRow(
                    systemIcon: "chart.bar.fill",
                    title: "Weekly summary",
                    subtitle: "A look at your week of growth.",
                    isOn: $weeklySummary
                )
            }
            .padding(14)
            .riseRichGlass(cornerRadius: RiseRadius.card)
            .onAppear(perform: load)
            .onChange(of: dailyMotivation) { _, _ in persist() }
            .onChange(of: eveningReflection) { _, _ in persist() }
            .onChange(of: intentionReminder) { _, _ in persist() }
            .onChange(of: streakUpdates) { _, _ in persist() }
            .onChange(of: weeklySummary) { _, _ in persist() }
        }
    }

    private func toggleRow(
        asset: String? = nil,
        systemIcon: String? = nil,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 12) {
            if let asset {
                ProfileSettingRow(icon: asset, title: title, subtitle: subtitle, usesAssetIcon: true)
            } else if let systemIcon {
                ProfileSettingRow(icon: systemIcon, title: title, subtitle: subtitle)
            }
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(RiseColors.accentSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                .fill(RiseColors.surfaceInset.opacity(0.65))
        )
    }

    private func load() {
        let defaults = UserDefaults.standard
        dailyMotivation = defaults.object(forKey: "notif_daily_motivation") as? Bool ?? true
        eveningReflection = defaults.object(forKey: "notif_evening_reflection") as? Bool ?? true
        intentionReminder = defaults.object(forKey: "notif_intention_reminder") as? Bool ?? true
        streakUpdates = defaults.object(forKey: "notif_streak_updates") as? Bool ?? true
        weeklySummary = defaults.object(forKey: "notif_weekly_summary") as? Bool ?? false
    }

    private func persist() {
        let defaults = UserDefaults.standard
        defaults.set(dailyMotivation, forKey: "notif_daily_motivation")
        defaults.set(eveningReflection, forKey: "notif_evening_reflection")
        defaults.set(intentionReminder, forKey: "notif_intention_reminder")
        defaults.set(streakUpdates, forKey: "notif_streak_updates")
        defaults.set(weeklySummary, forKey: "notif_weekly_summary")

        UserProfileStore.shared.notificationsDailyMotivation = dailyMotivation
        UserProfileStore.shared.notificationsEveningReflection = eveningReflection
        UserProfileStore.shared.notificationsIntentionReminder = intentionReminder
        UserProfileStore.shared.notificationsStreakUpdates = streakUpdates
        UserProfileStore.shared.notificationsWeeklySummary = weeklySummary
    }
}

#Preview {
    NotificationPreferencesView()
}
