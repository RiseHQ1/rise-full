//
//  ContentServiceProtocol.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Service protocol coordinating domain content operations.
public protocol ContentServiceProtocol: Sendable {
    func getDailyMotivation() async throws -> MotivationItem
    func getAffirmations(for focus: FocusArea?) async throws -> [Affirmation]
}
