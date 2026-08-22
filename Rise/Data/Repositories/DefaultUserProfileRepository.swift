//
//  DefaultUserProfileRepository.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// In-memory/UserDefaults-backed implementation of UserProfileRepositoryProtocol.
public final class DefaultUserProfileRepository: UserProfileRepositoryProtocol, @unchecked Sendable {
    private var cachedProfile: UserProfile?
    
    public init() {
        // Load initial profile placeholder if exists
        self.cachedProfile = UserProfile(name: "Friend")
    }
    
    public func getUserProfile() async throws -> UserProfile? {
        return cachedProfile
    }
    
    public func saveUserProfile(_ profile: UserProfile) async throws {
        self.cachedProfile = profile
    }
}
