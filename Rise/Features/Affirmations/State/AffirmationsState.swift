//
//  AffirmationsState.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation
import Observation

@Observable
@MainActor
public final class AffirmationsState {
    public enum Category: String, CaseIterable, Identifiable, Hashable, Sendable {
        case all
        case morning
        case confidence
        case growth
        case gratitude

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .all: return "All"
            case .morning: return "Morning"
            case .confidence: return "Confidence"
            case .growth: return "Growth"
            case .gratitude: return "Gratitude"
            }
        }

        public var systemIcon: String {
            switch self {
            case .all: return "square.grid.2x2.fill"
            case .morning: return "sun.max.fill"
            case .confidence: return "person.fill"
            case .growth: return "leaf.fill"
            case .gratitude: return "heart.fill"
            }
        }

        public var accentHex: String {
            switch self {
            case .all: return "#8B5CF6"
            case .morning: return "#F59E0B"
            case .confidence: return "#8B5CF6"
            case .growth: return "#10B981"
            case .gratitude: return "#EC4899"
            }
        }
    }

    public struct Item: Identifiable, Hashable, Sendable {
        public let id: UUID
        public let text: String
        public let category: Category
        public let tagline: String
        public var isSaved: Bool

        public init(
            id: UUID = UUID(),
            text: String,
            category: Category,
            tagline: String,
            isSaved: Bool = false
        ) {
            self.id = id
            self.text = text
            self.category = category
            self.tagline = tagline
            self.isSaved = isSaved
        }

        public var accentHex: String {
            category.accentHex
        }

        public var systemIcon: String {
            category.systemIcon
        }
    }

    public struct HeroSlide: Identifiable, Hashable, Sendable {
        public let id: UUID
        public let eyebrow: String
        public let text: String
        public let caption: String
        public let imageName: String
        public let linkedItemId: UUID

        public init(
            id: UUID = UUID(),
            eyebrow: String,
            text: String,
            caption: String,
            imageName: String,
            linkedItemId: UUID
        ) {
            self.id = id
            self.eyebrow = eyebrow
            self.text = text
            self.caption = caption
            self.imageName = imageName
            self.linkedItemId = linkedItemId
        }
    }

    public var selectedCategory: Category = .all
    public var heroIndex: Int = 0
    public var items: [Item] = RiseMotivationCatalog.shared.affirmations
    public var showCreateSheet = false
    public var draftAffirmation = ""

    public var heroSlides: [HeroSlide] = []
    public var todaysPickId: UUID?

    public init() {
        configureFeatured()
    }

    public var filteredItems: [Item] {
        guard selectedCategory != .all else { return items }
        return items.filter { $0.category == selectedCategory }
    }

    public var todaysPick: Item? {
        guard let todaysPickId else { return items.first }
        return items.first(where: { $0.id == todaysPickId }) ?? items.first
    }

    public func selectCategory(_ category: Category) {
        selectedCategory = category
    }

    public func toggleSaved(_ id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isSaved.toggle()
        let item = items[index]
        SavedContentStore.shared.toggleSave(
            title: item.text,
            subtitle: item.tagline,
            category: "Affirmation",
            assetName: "onboarding_summary_bg"
        )
    }

    public func isSaved(_ id: UUID) -> Bool {
        guard let item = items.first(where: { $0.id == id }) else { return false }
        return SavedContentStore.shared.isSaved(title: item.text) || item.isSaved
    }

    public func openReader(for id: UUID) {
        let queue = filteredItems.contains(where: { $0.id == id }) ? filteredItems : items
        AffirmationsReaderSession.shared.prepare(items: queue, initialId: id)
    }

    @discardableResult
    public func addDraftAffirmation() -> UUID? {
        let trimmed = draftAffirmation.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let item = Item(
            text: trimmed,
            category: .growth,
            tagline: "Written by you",
            isSaved: true
        )
        items.insert(item, at: 0)
        SavedContentStore.shared.save(
            item: SavedItem(
                title: item.text,
                subtitle: item.tagline,
                category: "Affirmation",
                assetName: "onboarding_summary_bg"
            )
        )
        draftAffirmation = ""
        showCreateSheet = false
        openReader(for: item.id)
        return item.id
    }

    private func configureFeatured() {
        guard items.count >= 4 else { return }
        todaysPickId = items[2].id
        heroSlides = [
            HeroSlide(
                eyebrow: "Daily reminder",
                text: items[0].text,
                caption: "Believe it. Live it. Become it.",
                imageName: "onboarding_welcome_bg",
                linkedItemId: items[0].id
            ),
            HeroSlide(
                eyebrow: "Morning light",
                text: items[1].text,
                caption: "Start soft. Rise steady.",
                imageName: "onboarding_summary_bg",
                linkedItemId: items[1].id
            ),
            HeroSlide(
                eyebrow: "Today's focus",
                text: items[2].text,
                caption: "Progress over perfection.",
                imageName: "onboarding_motivation_bg",
                linkedItemId: items[2].id
            ),
            HeroSlide(
                eyebrow: "Quiet strength",
                text: items[3].text,
                caption: "You already have what you need.",
                imageName: "onboarding_focus_bg",
                linkedItemId: items[3].id
            ),
        ]
    }

    private static let seedItems: [Item] = [
        .init(
            text: "You are becoming the best version of yourself.",
            category: .growth,
            tagline: "Keep rising today",
            isSaved: true
        ),
        .init(
            text: "I wake with clarity, courage, and calm.",
            category: .morning,
            tagline: "Start the day gently"
        ),
        .init(
            text: "I choose progress over perfection.",
            category: .growth,
            tagline: "Today's pick"
        ),
        .init(
            text: "I am capable of amazing things.",
            category: .confidence,
            tagline: "Trust your next step"
        ),
        .init(
            text: "I am grateful for how far I've already come.",
            category: .gratitude,
            tagline: "Honor your journey"
        ),
        .init(
            text: "I move through today with quiet confidence.",
            category: .confidence,
            tagline: "Steady and strong"
        ),
        .init(
            text: "This morning, I choose presence over pressure.",
            category: .morning,
            tagline: "Begin with breath"
        ),
        .init(
            text: "Growth happens when I show up imperfectly.",
            category: .growth,
            tagline: "Keep going"
        ),
        .init(
            text: "I appreciate the small wins that shape me.",
            category: .gratitude,
            tagline: "Notice the good"
        ),
        .init(
            text: "I trust myself to take the next right step.",
            category: .confidence,
            tagline: "One step is enough"
        ),
        .init(
            text: "I give myself permission to rest and rise again.",
            category: .morning,
            tagline: "Balance fuels progress"
        ),
        .init(
            text: "I am becoming kinder to myself each day.",
            category: .gratitude,
            tagline: "Self-compassion first"
        ),
    ]
}
