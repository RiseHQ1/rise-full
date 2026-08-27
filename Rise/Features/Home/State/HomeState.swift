//
//  HomeState.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import Foundation
import Observation
import SwiftUI

/// Local UI state for the Home screen scaffolding.
@Observable
@MainActor
public final class HomeState {
    public struct Thought: Identifiable, Hashable, Sendable {
        public let id: UUID
        public let lines: [String]
        public let highlightedLine: String

        public init(
            id: UUID = UUID(),
            lines: [String],
            highlightedLine: String
        ) {
            self.id = id
            self.lines = lines
            self.highlightedLine = highlightedLine
        }

        public var shareText: String {
            (lines + [highlightedLine]).joined(separator: " ")
        }
    }

    public enum QuickAction: String, CaseIterable, Identifiable, Sendable {
        case motivate
        case stressed
        case focus
        case encourage
        case eveningReflection

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .motivate: return RiseL10n.tr("action.motivate")
            case .stressed: return RiseL10n.tr("action.stressed")
            case .focus: return RiseL10n.tr("action.focus")
            case .encourage: return RiseL10n.tr("action.encourage")
            case .eveningReflection: return RiseL10n.tr("action.eveningReflection")
            }
        }

        public var iconAssetName: String {
            switch self {
            case .motivate: return "onboarding_icon_lightning"
            case .stressed: return "onboarding_icon_calm"
            case .focus: return "onboarding_icon_target"
            case .encourage: return "onboarding_icon_heart"
            case .eveningReflection: return "onboarding_icon_studying"
            }
        }
    }

    // MARK: - Thoughts

    public var thoughts: [Thought] = RiseMotivationCatalog.shared.dailyThoughts

    public var thoughtIndex: Int = {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return (dayOfYear - 1) % max(RiseMotivationCatalog.shared.dailyThoughts.count, 1)
    }()

    public var currentThought: Thought {
        thoughts[safe: thoughtIndex] ?? thoughts.first ?? Thought(
            lines: ["Small steps today,", "stronger tomorrow."],
            highlightedLine: "Keep showing up."
        )
    }

    public var isThoughtFavorited: Bool {
        SavedContentStore.shared.isSaved(title: currentThought.shareText)
    }

    // MARK: - Intention

    public var intentionText: String = ""

    public var hasActiveIntention: Bool {
        UserProfileStore.shared.todayIntentionCompleted && UserProfileStore.shared.todayIntention != nil
    }

    public var activeIntentionText: String {
        UserProfileStore.shared.todayIntention ?? ""
    }

    public var userDisplayName: String {
        UserProfileStore.shared.firstName
    }

    // MARK: - Actions

    public var lastQuickAction: QuickAction?
    public var didTapMenu: Bool = false
    public var didTapNotifications: Bool = false
    public var didTapNeedSomething: Bool = false

    public init() {}

    public func nextThought() {
        if thoughtIndex < thoughts.count - 1 {
            thoughtIndex += 1
        } else {
            thoughtIndex = 0
        }
    }

    public func prevThought() {
        if thoughtIndex > 0 {
            thoughtIndex -= 1
        } else {
            thoughtIndex = thoughts.count - 1
        }
    }

    public func selectThought(at index: Int) {
        if thoughts.indices.contains(index) {
            thoughtIndex = index
        }
    }

    public func toggleThoughtFavorite() {
        let text = currentThought.shareText
        SavedContentStore.shared.toggleSave(
            title: text,
            subtitle: "Daily Thought",
            category: "Quote",
            assetName: "home_tab_bg"
        )
    }

    public func setIntention() {
        let trimmed = intentionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        UserProfileStore.shared.saveDailyIntention(
            text: trimmed,
            focus: "Mindset",
            action: "Take action today",
            why: "Consistency matters"
        )
        intentionText = ""
    }

    public func selectQuickAction(_ action: QuickAction) {
        lastQuickAction = action
    }

    /// Asynchronously fetches today's live thought from the production server.
    public func loadServerContent() async {
        do {
            struct ThoughtServerItem: Decodable {
                let quote: String
                let author: String
                let category: String
            }
            let serverItem: ThoughtServerItem = try await RiseAPIClient.shared.request(
                endpoint: "motivation/daily-thought",
                method: "GET",
                requiresAuth: false
            )
            let words = serverItem.quote.split(separator: " ").map(String.init)
            if words.count >= 6 {
                let splitPoint = words.count / 2
                let line1 = words[0 ..< splitPoint].joined(separator: " ")
                let line2 = words[splitPoint ..< max(words.count - 3, splitPoint + 1)].joined(separator: " ")
                let highlight = words[max(words.count - 3, splitPoint + 1) ..< words.count].joined(separator: " ")
                let newThought = Thought(
                    lines: [line1, line2],
                    highlightedLine: highlight.isEmpty ? "— \(serverItem.author)" : highlight
                )
                thoughts.insert(newThought, at: 0)
                thoughtIndex = 0
            }
            RiseLogger.info("Loaded today's motivation from live backend: \(serverItem.quote)")
        } catch {
            RiseLogger.warning("Live motivation fetch fallback to local bank: \(error.localizedDescription)")
        }
    }

    public var greetingPrefix: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5 ..< 12: return RiseL10n.tr("greeting.morning")
        case 12 ..< 17: return RiseL10n.tr("greeting.afternoon")
        case 17 ..< 22: return RiseL10n.tr("greeting.evening")
        default: return RiseL10n.tr("greeting.morning")
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
