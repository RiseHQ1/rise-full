//
//  ContentRepositoryProtocol.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Protocol abstracting content data retrieval.
public protocol ContentRepositoryProtocol: Sendable {
    func fetchDailyMotivation() async throws -> MotivationItem
    func fetchAffirmations(for focus: FocusArea?) async throws -> [Affirmation]
}
