//
//  RisePlanEditView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// View & edit Morning Boost, Evening Reflection, and Focus Time.
public struct RisePlanEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var morningTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var eveningTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var focusMinutes: Double = 10

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    public init() {}

    public var body: some View {
        ProfileSubscreenScaffold(
            title: "Your Rise Plan",
            subtitle: "Adjust when Rise shows up for you."
        ) {
            VStack(alignment: .leading, spacing: RiseSpacing.md) {
                VStack(spacing: 10) {
                    planTimeRow(
                        asset: "onboarding_icon_sun",
                        title: "Morning Boost",
                        subtitle: "Start your day with motivation.",
                        selection: $morningTime
                    )
                    planTimeRow(
                        asset: "onboarding_icon_moon",
                        title: "Evening Reflection",
                        subtitle: "End your day with reflection.",
                        selection: $eveningTime
                    )

                    VStack(alignment: .leading, spacing: 10) {
                        ProfileSettingRow(
                            icon: "onboarding_icon_target",
                            title: "Focus Time",
                            subtitle: "\(Int(focusMinutes)) min/day",
                            usesAssetIcon: true
                        )
                        Slider(value: $focusMinutes, in: 5 ... 30, step: 5)
                            .tint(RiseColors.accentSecondary)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: RiseRadius.control, style: .continuous)
                            .fill(RiseColors.surfaceInset.opacity(0.65))
                    )
                }
                .padding(14)
                .riseRichGlass(cornerRadius: RiseRadius.card)

                RisePrimaryButton("Save Plan", iconName: "checkmark", style: .gold) {
                    let morningStr = timeFormatter.string(from: morningTime)
                    let eveningStr = timeFormatter.string(from: eveningTime)
                    let focusMins = Int(focusMinutes)
                    UserProfileStore.shared.morningBoostTime = morningStr
                    UserProfileStore.shared.eveningReflectionTime = eveningStr
                    UserProfileStore.shared.planFocusMinutes = focusMins
                    UserDefaults.standard.set(morningStr, forKey: "profile_morning_boost_time")
                    UserDefaults.standard.set(eveningStr, forKey: "profile_evening_reflection_time")
                    UserDefaults.standard.set("\(focusMins) min/day", forKey: "profile_focus_duration")
                    dismiss()
                }
            }
        }
        .onAppear(perform: load)
    }

    private func planTimeRow(
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
        if let focus = UserDefaults.standard.string(forKey: "profile_focus_duration"),
           let minutes = Int(focus.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        {
            focusMinutes = Double(minutes)
        }
    }
}

#Preview {
    RisePlanEditView()
}
