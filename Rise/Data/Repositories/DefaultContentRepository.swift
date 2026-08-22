//
//  DefaultContentRepository.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Default seed-based implementation of ContentRepositoryProtocol.
public final class DefaultContentRepository: ContentRepositoryProtocol, @unchecked Sendable {
    private let seedMotivation = MotivationItem(
        quote: "Your calm mind is the ultimate weapon against your challenges.",
        author: "Marcus Aurelius",
        category: .mindfulness
    )
    
    private let seedAffirmations = [
        Affirmation(text: "I am centered, focused, and ready for today.", category: .mindfulness),
        Affirmation(text: "I embrace challenges with quiet confidence.", category: .resilience),
        Affirmation(text: "Peace begins from within my own breath.", category: .clarity)
    ]
    
    public init() {}
    
    public func fetchDailyMotivation() async throws -> MotivationItem {
        return seedMotivation
    }
    
    public func fetchAffirmations(for focus: FocusArea?) async throws -> [Affirmation] {
        if let focus {
            return seedAffirmations.filter { $0.category == focus }
        }
        return seedAffirmations
    }
}
