//
//  UserProfileRepositoryProtocol.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Protocol abstracting user profile persistence.
public protocol UserProfileRepositoryProtocol: Sendable {
    func getUserProfile() async throws -> UserProfile?
    func saveUserProfile(_ profile: UserProfile) async throws
}
