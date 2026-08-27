//
//  JournalStore.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation
import Observation
import SwiftUI

/// Unified journal model with formatting helpers.
public struct JournalEntryItem: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var title: String
    public var content: String
    public var mood: String
    public var assetName: String
    public var date: Date
    public var isPrivate: Bool

    public init(
        id: UUID = UUID(),
        title: String,
        content: String,
        mood: String = "Good",
        assetName: String = "onboarding_motivation_bg",
        date: Date = Date(),
        isPrivate: Bool = true
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.mood = mood
        self.assetName = assetName
        self.date = date
        self.isPrivate = isPrivate
    }

    public var preview: String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count > 90 {
            return String(trimmed.prefix(90)) + "…"
        }
        return trimmed.isEmpty ? "No content" : trimmed
    }

    public var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy • h:mm a"
        return formatter.string(from: date)
    }

    public var shortDateLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    public var wordCount: Int {
        let words = content.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        return words.count
    }
}

/// Centralized observable reactive store for Journal entries across Rise.
@Observable
@MainActor
public final class JournalStore {
    public static let shared = JournalStore()

    public var entries: [JournalEntryItem] = []
    public var streakDays: Int = 7
    public var totalWordsWritten: Int = 1420

    private let storageKey = "rise_journal_entries_v1"

    public init() {
        loadEntries()
    }

    public func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([JournalEntryItem].self, from: data),
           !decoded.isEmpty
        {
            entries = decoded
            return
        }

        // Seed initial realistic entries
        entries = [
            JournalEntryItem(
                title: "Grateful for the little wins today.",
                content: """
                Finished my morning routine without looking at notifications first thing. \
                Sat at the balcony with my tea and wrote down my focus priorities. \
                It wasn't a perfect day, but I showed up with intention and stayed grounded.
                """,
                mood: "Good",
                assetName: "onboarding_motivation_bg",
                date: Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date()
            ),
            JournalEntryItem(
                title: "Slowing down helped me reset.",
                content: """
                Took a walk in the afternoon and let my mind wander without pressure. \
                When I feel overwhelmed, taking two minutes of box breathing makes all the difference.
                """,
                mood: "Calm",
                assetName: "onboarding_focus_bg",
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            ),
            JournalEntryItem(
                title: "A reminder to keep going.",
                content: """
                Consistency is not about perfection; it's about returning to what matters after getting off track. \
                Ready for the week ahead with a clear mind.
                """,
                mood: "Okay",
                assetName: "onboarding_summary_bg",
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
            ),
            JournalEntryItem(
                title: "Finding focus in the quiet mornings.",
                content: """
                Waking up early gives me space to think before the world asks for my attention. \
                Setting one clear daily intention keeps me anchored.
                """,
                mood: "Good",
                assetName: "splash_sunrise_scene",
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
            ),
        ]
        persist()
    }

    public func addEntry(
        title: String,
        content: String,
        mood: String = "Good",
        assetName: String = "onboarding_motivation_bg"
    ) -> JournalEntryItem {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalTitle = trimmedTitle.isEmpty ? "Reflection on \(Date().formatted(date: .abbreviated, time: .omitted))" : trimmedTitle

        let newEntry = JournalEntryItem(
            title: finalTitle,
            content: content,
            mood: mood,
            assetName: assetName,
            date: Date()
        )

        entries.insert(newEntry, at: 0)
        streakDays += 1
        persist()
        return newEntry
    }

    public func deleteEntry(id: UUID) {
        entries.removeAll { $0.id == id }
        persist()
    }

    public func updateEntry(id: UUID, title: String, content: String, mood: String) -> Bool {
        guard let index = entries.firstIndex(where: { $0.id == id }) else { return false }
        entries[index].title = title
        entries[index].content = content
        entries[index].mood = mood
        persist()
        return true
    }

    public func entry(for id: UUID) -> JournalEntryItem? {
        entries.first { $0.id == id }
    }

    public func entry(forTitle title: String) -> JournalEntryItem? {
        entries.first { $0.title.lowercased() == title.lowercased() }
    }

    private func persist() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
