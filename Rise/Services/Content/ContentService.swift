//
//  ContentService.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Concrete service handling content coordination and caching.
public final class ContentService: ContentServiceProtocol, @unchecked Sendable {
    private let contentRepository: ContentRepositoryProtocol

    public init(contentRepository: ContentRepositoryProtocol) {
        self.contentRepository = contentRepository
    }

    public func getDailyMotivation() async throws -> MotivationItem {
        return try await contentRepository.fetchDailyMotivation()
    }

    public func getAffirmations(for focus: FocusArea? = nil) async throws -> [Affirmation] {
        return try await contentRepository.fetchAffirmations(for: focus)
    }
}
