//
//  ReminderScheduleView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Set when motivation and reflection reminders fire.
public struct ReminderScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var morningTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var eveningTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var middayNudge = false
    @State private var middayTime = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date()) ?? Date()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    public init() {}

    public var body: some View {
        ProfileSubscreenScaffold(
            title: "Reminder Schedule",
            subtitle: "Set your motivation times."
        ) {
            VStack(alignment: .leading, spacing: RiseSpacing.md) {
                VStack(spacing: 10) {
                    timeRow(
                        asset: "onboarding_icon_sun",
                        title: "Morning Boost",
                        subtitle: "Start strong.",
                        selection: $morningTime
                    )
                    timeRow(
                        asset: "onboarding_icon_moon",
                        title: "Evening Reflection",
                        subtitle: "Wind down with intention.",
                        selection: $eveningTime
                    )

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 12) {
                            ProfileSettingRow(
                                icon: "bell.badge",
                                title: "Midday nudge",
                                subtitle: "A quick check-in when energy dips."
                            )
                            Toggle("", isOn: $middayNudge)
                                .labelsHidden()
                                .tint(RiseColors.accentSecondary)
                        }
                        if middayNudge {
                            DatePicker("", selection: $middayTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .colorScheme(.dark)
                                .tint(RiseColors.accentSecondary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                            .fill(RiseColors.surfaceInset.opacity(0.65))
                    )
                }
                .padding(14)
                .riseRichGlass(cornerRadius: RiseRadius.card)

                RisePrimaryButton("Save Schedule", iconName: "checkmark", style: .gold) {
                    let morningStr = timeFormatter.string(from: morningTime)
                    let eveningStr = timeFormatter.string(from: eveningTime)
                    let middayStr = timeFormatter.string(from: middayTime)
                    UserProfileStore.shared.morningBoostTime = morningStr
                    UserProfileStore.shared.eveningReflectionTime = eveningStr
                    UserProfileStore.shared.middayNudgeEnabled = middayNudge
                    UserProfileStore.shared.middayNudgeTime = middayStr
                    UserDefaults.standard.set(morningStr, forKey: "profile_morning_boost_time")
                    UserDefaults.standard.set(eveningStr, forKey: "profile_evening_reflection_time")
                    UserDefaults.standard.set(middayNudge, forKey: "profile_midday_nudge_enabled")
                    UserDefaults.standard.set(middayStr, forKey: "profile_midday_nudge_time")
                    dismiss()
                }
            }
        }
        .onAppear(perform: load)
    }

    private func timeRow(
        asset: String,
        title: String,
        subtitle: String,
        selection: Binding<Date>
    ) -> some View {
        HStack(spacing: 12) {
            ProfileSettingRow(icon: asset, title: title, subtitle: subtitle, usesAssetIcon: true)
            DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .colorScheme(.dark)
                .tint(RiseColors.accentSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                .fill(RiseColors.surfaceInset.opacity(0.65))
        )
    }

    private func load() {
        if let morning = UserDefaults.standard.string(forKey: "profile_morning_boost_time"),
           let date = timeFormatter.date(from: morning)
        {
            morningTime = date
        }
        if let evening = UserDefaults.standard.string(forKey: "profile_evening_reflection_time"),
           let date = timeFormatter.date(from: evening)
        {
            eveningTime = date
        }
        middayNudge = UserDefaults.standard.bool(forKey: "profile_midday_nudge_enabled")
        if let midday = UserDefaults.standard.string(forKey: "profile_midday_nudge_time"),
           let date = timeFormatter.date(from: midday)
        {
            middayTime = date
        }
    }
}

#Preview {
    ReminderScheduleView()
}
