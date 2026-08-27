//
//  JournalState.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import Foundation
import Observation
import SwiftUI

@Observable
@MainActor
public final class JournalState {
    public enum Feeling: String, CaseIterable, Identifiable, Sendable {
        case good
        case calm
        case okay
        case struggling
        case overwhelmed

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .good: return RiseL10n.tr("feeling.great")
            case .calm: return RiseL10n.tr("feeling.calm")
            case .okay: return RiseL10n.tr("feeling.okay")
            case .struggling: return RiseL10n.tr("feeling.low")
            case .overwhelmed: return RiseL10n.tr("feeling.tired")
            }
        }

        public var iconAssetName: String {
            switch self {
            case .good: return "onboarding_icon_smiley"
            case .calm: return "onboarding_icon_calm"
            case .okay: return "onboarding_icon_sun"
            case .struggling: return "onboarding_icon_stress"
            case .overwhelmed: return "onboarding_icon_fire"
            }
        }
    }

    public struct Prompt: Identifiable, Hashable, Sendable {
        public let id = UUID()
        public let text: String
        public let iconAssetName: String
    }

    public var selectedFeeling: Feeling? = .good
    public var entryText: String = ""
    public var didTapMenu: Bool = false
    public var didTapCalendar: Bool = false
    public var didTapSeeAll: Bool = false
    public var didSaveSuccessfully: Bool = false

    public var prompts: [Prompt] = [
        .init(text: "What made me smile today?", iconAssetName: "onboarding_icon_sun"),
        .init(text: "What am I grateful for right now?", iconAssetName: "onboarding_icon_lightbulb"),
        .init(text: "What’s something I learned today?", iconAssetName: "onboarding_icon_sprout_soil"),
        .init(text: "How did I show up for myself?", iconAssetName: "onboarding_icon_heart"),
    ]

    public var entries: [JournalEntryItem] {
        JournalStore.shared.entries
    }

    public var streakDays: Int {
        JournalStore.shared.streakDays
    }

    public var streakDaysCompleted: Int {
        min(7, max(1, streakDays % 7 == 0 ? 7 : streakDays % 7))
    }

    public var wordCount: Int {
        entryText.split { $0.isWhitespace || $0.isNewline }.count
    }

    public init() {}

    public func applyPrompt(_ prompt: Prompt) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        if entryText.isEmpty {
            entryText = prompt.text + "\n\n"
        } else {
            entryText += "\n\n" + prompt.text + "\n"
        }
    }

    public func saveEntry() {
        let trimmed = entryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let firstLine = trimmed.split(separator: "\n").first.map(String.init) ?? "Journal Entry"
        let title = String(firstLine.prefix(48))
        let moodName = selectedFeeling?.title ?? "Good"

        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)

        _ = JournalStore.shared.addEntry(
            title: title,
            content: trimmed,
            mood: moodName,
            assetName: "onboarding_summary_bg"
        )

        entryText = ""
        didSaveSuccessfully = true
    }
}
