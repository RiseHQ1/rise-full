//
//  SavedContentStore.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation
import Observation
import SwiftUI

/// Unified saved item across quotes, affirmations, reflections, and exercises.
public struct SavedItem: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var title: String
    public var subtitle: String
    public var category: String
    public var assetName: String
    public var dateAdded: Date
    public var iconName: String

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String = "",
        category: String = "Motivation",
        assetName: String = "onboarding_motivation_bg",
        dateAdded: Date = Date(),
        iconName: String = "bookmark.fill"
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.assetName = assetName
        self.dateAdded = dateAdded
        self.iconName = iconName
    }
}

/// Centralized observable reactive store for Bookmarks & Saved Items across Rise.
@Observable
@MainActor
public final class SavedContentStore {
    public static let shared = SavedContentStore()

    public var items: [SavedItem] = []

    private let storageKey = "rise_saved_items_v1"

    public init() {
        loadItems()
    }

    public func loadItems() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([SavedItem].self, from: data),
           !decoded.isEmpty
        {
            items = decoded
            return
        }

        // Seed initial favorites
        items = [
            SavedItem(
                title: "Keep showing up for yourself.",
                subtitle: "Small consistent steps create lasting change.",
                category: "Motivation",
                assetName: "onboarding_motivation_bg",
                iconName: "quote.opening"
            ),
            SavedItem(
                title: "I choose calm over chaos today.",
                subtitle: "I am grounded, peaceful, and in control of my attention.",
                category: "Affirmation",
                assetName: "onboarding_summary_bg",
                iconName: "sparkles"
            ),
            SavedItem(
                title: "Box Breathing Reset",
                subtitle: "2-minute box breathing session for instant clarity.",
                category: "Breathwork",
                assetName: "onboarding_focus_bg",
                iconName: "wind"
            ),
            SavedItem(
                title: "Discipline is choosing what you want most over what you want now.",
                subtitle: "Every small choice builds the person you want to become.",
                category: "Motivation",
                assetName: "onboarding_improvements_bg",
                iconName: "target"
            ),
        ]
        persist()
    }

    public func isSaved(title: String) -> Bool {
        items.contains { $0.title.lowercased() == title.lowercased() }
    }

    public func toggleSave(
        title: String,
        subtitle: String = "",
        category: String = "Motivation",
        assetName: String = "onboarding_motivation_bg"
    ) {
        let isNowSaved: Bool
        let syncId: UUID
        if let index = items.firstIndex(where: { $0.title.lowercased() == title.lowercased() }) {
            syncId = items[index].id
            items.remove(at: index)
            isNowSaved = false
        } else {
            let newItem = SavedItem(
                title: title,
                subtitle: subtitle,
                category: category,
                assetName: assetName
            )
            syncId = newItem.id
            items.insert(newItem, at: 0)
            isNowSaved = true
        }
        persist()

        // Sync Favorite to live PostgreSQL Database via Delta Sync
        Task {
            guard RiseAPIClient.shared.isAuthenticated else { return }
            do {
                let isoFormatter = ISO8601DateFormatter()
                isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let nowIso = isoFormatter.string(from: Date())

                struct SyncSavedItemPayload: Encodable {
                    let syncId: String
                    let title: String
                    let subtitle: String?
                    let category: String
                    let assetName: String
                    let isFavorite: Bool
                    let clientUpdatedAt: String
                    let isDeleted: Bool
                    let version: Int
                }

                struct DeltaSyncPayload: Encodable {
                    let savedItems: [SyncSavedItemPayload]
                }

                let savedPayload = SyncSavedItemPayload(
                    syncId: syncId.uuidString,
                    title: title,
                    subtitle: subtitle.isEmpty ? nil : subtitle,
                    category: category,
                    assetName: assetName,
                    isFavorite: isNowSaved,
                    clientUpdatedAt: nowIso,
                    isDeleted: !isNowSaved,
                    version: 1
                )

                let deltaPayload = DeltaSyncPayload(savedItems: [savedPayload])

                struct DeltaSyncResponse: Decodable {
                    let serverTimestamp: String
                }

                let _: DeltaSyncResponse = try await RiseAPIClient.shared.request(
                    endpoint: "sync/delta",
                    method: "POST",
                    body: deltaPayload
                )
                RiseLogger.info("Favorite successfully synchronized to PostgreSQL saved_contents table.")
            } catch {
                RiseLogger.warning("Favorite sync notice: \(error.localizedDescription)")
            }
        }
    }

    public func save(item: SavedItem) {
        if !items.contains(where: { $0.title.lowercased() == item.title.lowercased() }) {
            items.insert(item, at: 0)
            persist()
        }
    }

    public func remove(title: String) {
        items.removeAll { $0.title.lowercased() == title.lowercased() }
        persist()
    }

    public func remove(id: UUID) {
        items.removeAll { $0.id == id }
        persist()
    }

    private func persist() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
