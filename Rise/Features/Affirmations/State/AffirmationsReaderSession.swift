//
//  AffirmationsReaderSession.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation
import Observation

/// Holds the affirmation queue for a pushed `AffirmationReaderView`.
/// Prepared by `AffirmationsView` right before `router.push(.affirmationReader)`.
@Observable
@MainActor
public final class AffirmationsReaderSession {
    public static let shared = AffirmationsReaderSession()

    public private(set) var items: [AffirmationsState.Item] = []
    public private(set) var initialId: UUID?

    private init() {}

    public func prepare(items: [AffirmationsState.Item], initialId: UUID) {
        self.items = items
        self.initialId = initialId
    }

    public func clear() {
        items = []
        initialId = nil
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
}
