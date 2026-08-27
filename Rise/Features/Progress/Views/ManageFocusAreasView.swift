//
//  ManageFocusAreasView.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Lets the user choose which focus areas appear on Progress.
public struct ManageFocusAreasView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected: Set<String> = []

    private let options: [(id: String, title: String, subtitle: String, icon: String)] = [
        ("discipline", "Discipline", "Build habits and stay consistent.", "onboarding_icon_discipline"),
        ("mindset", "Mindset", "Train how you think and respond.", "onboarding_icon_brain"),
        ("selfGrowth", "Self Growth", "Grow into your best self.", "onboarding_icon_growth"),
        ("motivation", "Motivation", "Stay inspired and keep moving.", "onboarding_icon_motivation"),
        ("stress", "Stress Relief", "Find calm in your daily life.", "onboarding_icon_stress"),
        ("fitness", "Fitness", "Care for body and mind.", "onboarding_icon_fitness"),
        ("studying", "Studying", "Focus better on learning goals.", "onboarding_icon_studying"),
        ("work", "Work", "Be productive and hit milestones.", "onboarding_icon_work"),
        ("relationships", "Relationships", "Build stronger connections.", "onboarding_icon_relationships"),
    ]

    public init() {}

    public var body: some View {
        ProfileSubscreenScaffold(
            title: "Focus Areas",
            subtitle: "Choose up to 3 areas to track on Progress."
        ) {
            VStack(alignment: .leading, spacing: RiseSpacing.md) {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                    ],
                    spacing: 10
                ) {
                    ForEach(options, id: \.id) { option in
                        focusCard(option)
                    }
                }

                Text("\(selected.count)/3 selected")
                    .font(RiseTypography.footnoteMedium)
                    .foregroundStyle(RiseColors.textSecondary)

                RisePrimaryButton("Save Focus Areas", iconName: "checkmark", style: .gold) {
                    let ids = Array(selected)
                    UserProfileStore.shared.activeFocusAreaIds = ids
                    UserDefaults.standard.set(ids, forKey: "progress_managed_focus_ids")
                    dismiss()
                }
                .disabled(selected.isEmpty)
            }
        }
        .onAppear(perform: load)
    }

    private func focusCard(_ option: (id: String, title: String, subtitle: String, icon: String)) -> some View {
        let isOn = selected.contains(option.id)
        return Button {
            toggle(option.id)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Image(option.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                    Spacer(minLength: 0)
                    Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                        .font(RiseTypography.headline)
                        .foregroundStyle(isOn ? RiseColors.accentSecondary : RiseColors.textMuted)
                }

                Text(option.title)
                    .font(RiseTypography.subheadlineBold)
                    .foregroundStyle(RiseColors.textPrimary)
                Text(option.subtitle)
                    .font(RiseTypography.micro)
                    .foregroundStyle(RiseColors.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(RiseColors.surfaceInset.opacity(0.72))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isOn ? RiseColors.accentSecondary.opacity(0.85) : RiseColors.borderSoft,
                        lineWidth: isOn ? 1.5 : 1
                    )
            }
        }
        .buttonStyle(.plain)
    }

    private func toggle(_ id: String) {
        RiseHaptic.selection()
        if selected.contains(id) {
            selected.remove(id)
        } else if selected.count < 3 {
            selected.insert(id)
        }
    }

    private func load() {
        if let saved = UserDefaults.standard.array(forKey: "progress_managed_focus_ids") as? [String],
           !saved.isEmpty
        {
            selected = Set(saved.prefix(3))
        } else {
            selected = ["discipline", "mindset", "selfGrowth"]
        }
    }
}

#Preview {
    ManageFocusAreasView()
}
