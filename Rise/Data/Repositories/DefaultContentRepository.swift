//
//  DefaultContentRepository.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Default catalog-backed implementation of ContentRepositoryProtocol.
public final class DefaultContentRepository: ContentRepositoryProtocol, @unchecked Sendable {
    public init() {}

    public func fetchDailyMotivation() async throws -> MotivationItem {
        let quotes = RiseMotivationCatalog.shared.items
        let today = Date()
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: today) ?? 1
        let index = (dayOfYear - 1) % max(quotes.count, 1)
        let record = quotes[index]

        return MotivationItem(
            quote: record.quote,
            author: record.author,
            category: .mindfulness,
            date: today
        )
    }

    public func fetchAffirmations(for focus: FocusArea?) async throws -> [Affirmation] {
        let items = RiseMotivationCatalog.shared.affirmations
        return items.map { item in
            Affirmation(text: item.text, category: focus ?? .mindfulness)
        }
    }
}
