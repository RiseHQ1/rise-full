//
//  RiseAPIClient.swift
//  Rise
//
//  Production Swift networking client and sync coordinator for Rise Backend
//

import Foundation
import Security

/// Thread-safe Swift networking client for Rise Backend API.
public final class RiseAPIClient: @unchecked Sendable {
    public static let shared = RiseAPIClient()

    #if DEBUG
        public var baseURL = URL(string: AppConstants.serverBaseURL)!
    #else
        public var baseURL = URL(string: AppConstants.serverBaseURL)!
    #endif

    private let session: URLSession
    private let lock = NSLock()

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config)
    }

    // MARK: - Token Management (Keychain)

    public func setTokens(accessToken: String, refreshToken: String) {
        lock.lock()
        defer { lock.unlock() }
        saveKeychain(key: "rise_access_token", value: accessToken)
        saveKeychain(key: "rise_refresh_token", value: refreshToken)
    }

    public func clearTokens() {
        lock.lock()
        defer { lock.unlock() }
        deleteKeychain(key: "rise_access_token")
        deleteKeychain(key: "rise_refresh_token")
    }

    public var accessToken: String? {
        lock.lock()
        defer { lock.unlock() }
        return readKeychain(key: "rise_access_token")
    }

    public var refreshToken: String? {
        lock.lock()
        defer { lock.unlock() }
        return readKeychain(key: "rise_refresh_token")
    }

    public var isAuthenticated: Bool {
        accessToken != nil
    }

    // MARK: - Generic Authenticated Request Pipeline

    public func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: (any Encodable)? = nil,
        idempotencyKey: String? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let idempotencyKey {
            request.setValue(idempotencyKey, forHTTPHeaderField: "Idempotency-Key")
        }

        if requiresAuth, let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RiseAPIError.invalidResponse
        }

        // Automatic 401 Refresh and Retry
        if httpResponse.statusCode == 401 && requiresAuth, let refToken = refreshToken {
            let refreshed = try await attemptTokenRefresh(refreshToken: refToken)
            if refreshed {
                return try await self.request(
                    endpoint: endpoint,
                    method: method,
                    body: body,
                    idempotencyKey: idempotencyKey,
                    requiresAuth: true
                )
            } else {
                clearTokens()
                throw RiseAPIError.unauthorized
            }
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "HTTP \(httpResponse.statusCode)"
            throw RiseAPIError.serverError(statusCode: httpResponse.statusCode, message: errorMsg)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let envelope = try decoder.decode(APIResponseEnvelope<T>.self, from: data)
        return envelope.data
    }

    private func attemptTokenRefresh(refreshToken: String) async throws -> Bool {
        let url = baseURL.appendingPathComponent("auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["refreshToken": refreshToken])

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return false
        }

        struct RefreshResponse: Decodable {
            let tokens: TokenPair
        }
        struct TokenPair: Decodable {
            let accessToken: String
            let refreshToken: String
        }

        let envelope = try JSONDecoder().decode(APIResponseEnvelope<RefreshResponse>.self, from: data)
        setTokens(accessToken: envelope.data.tokens.accessToken, refreshToken: envelope.data.tokens.refreshToken)
        return true
    }

    // MARK: - Keychain Helpers

    private func saveKeychain(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        deleteKeychain(key: key)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func readKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    private func deleteKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - DTO Models & Error Types

public enum RiseAPIError: Error, LocalizedError {
    case unauthorized
    case invalidResponse
    case serverError(statusCode: Int, message: String)

    public var errorDescription: String? {
        switch self {
        case .unauthorized: return "Session expired. Please log in again."
        case .invalidResponse: return "Invalid server response."
        case let .serverError(code, msg): return "Server error (\(code)): \(msg)"
        }
    }
}

public struct APIResponseEnvelope<T: Decodable>: Decodable {
    public let success: Bool
    public let data: T
}

public struct UserDTO: Codable, Sendable {
    public let id: String
    public let email: String?
    public let name: String
    public let avatarUrl: String?
    public let focusAreas: [String]?
    public let onboardingComplete: Bool?
    public let timeZone: String
    public let role: String?
    public let morningBoostTime: String
    public let eveningReflectionTime: String
    public let focusDurationMinutes: Int
    public let motivationStyle: String
    public let subscriptionTier: String
    public let createdAt: String
}

public struct AuthResultDTO: Codable, Sendable {
    public let user: UserDTO
    public let tokens: AuthTokensDTO
}

public struct AuthTokensDTO: Codable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: String
}

public struct AIReflectionResponseDTO: Codable, Sendable {
    public let isCrisisDetected: Bool
    public let insight: String?
    public let stoicPerspective: String?
    public let actionableTakeaway: String?
    public let suggestedAffirmation: String?
    public let recommendedSoundscape: String?
}

public struct SubscriptionStatusDTO: Codable, Sendable {
    public let tier: String
    public let isPro: Bool
    public let expiresAt: String?
}

public struct MediaUploadSignatureDTO: Codable, Sendable {
    public let provider: String
    public let uploadUrl: String
    public let params: MediaUploadParamsDTO
}

public struct MediaUploadParamsDTO: Codable, Sendable {
    public let apiKey: String
    public let timestamp: Int
    public let folder: String
    public let signature: String
    public let transformation: String?

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case timestamp
        case folder
        case signature
        case transformation
    }
}

public struct MilestoneBadgeDTO: Codable, Sendable, Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let icon: String
    public let category: String
    public let isUnlocked: Bool
    public let progressPercentage: Double
}

public struct MilestonesResponseDTO: Codable, Sendable {
    public let unlockedCount: Int
    public let totalCount: Int
    public let badges: [MilestoneBadgeDTO]
}

public struct DailyPromptDTO: Codable, Sendable {
    public let timeOfDay: String
    public let prompt: String
    public let timestamp: String
}

public struct DailyThoughtDTO: Codable, Sendable, Identifiable {
    public let id: String
    public let quote: String
    public let author: String
    public let category: String
    public let tags: [String]
    public let assetName: String
}

public struct AffirmationDTO: Codable, Sendable, Identifiable {
    public let id: String
    public let text: String
    public let category: String
    public let tags: [String]
    public let accessLevel: String
    public let assetName: String
}

public struct RisePackDTO: Codable, Sendable, Identifiable {
    public let id: String
    public let slug: String
    public let title: String
    public let subtitle: String?
    public let description: String
    public let heroArtwork: String
    public let theme: String?
    public let category: String
    public let durationDays: Int
    public let accessLevel: String
    public let storeKitProductId: String?
    public let priceTier: String?
    public let version: Int?
    public let isUnlocked: Bool
    public let items: [PackItemDTO]?
    public let progress: PackProgressDTO?
}

public struct PackItemDTO: Codable, Sendable {
    public let day: Int
    public let title: String
    public let subtitle: String?
    public let type: String
    public let content: String
    public let durationMinutes: Int
    public let assetName: String?
}

public struct PackProgressDTO: Codable, Sendable {
    public let currentDay: Int
    public let completedItemCount: Int?
    public let completedItemIds: [String]?
    public let isCompleted: Bool
    public let completedAt: String?
    public let lastEngagedAt: String
}

public struct DailyIntentionDTO: Codable, Sendable, Identifiable {
    public var id: String {
        syncId
    }

    public let syncId: String
    public let date: String
    public let text: String
    public let category: String
    public let isCustom: Bool
    public let isCompleted: Bool
    public let completedAt: String?
}

public struct BreathingResetDTO: Codable, Sendable, Identifiable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let durationMinutes: Int
    public let systemIcon: String
}

public struct DiscoveryHubDTO: Codable, Sendable {
    public let dailyThought: DailyThoughtDTO?
    public let dailyAffirmation: AffirmationDTO?
    public let featuredPacks: [RisePackDTO]
    public let allPacks: [RisePackDTO]
    public let categories: [String]
    public let breathingResets: [BreathingResetDTO]
}

public struct UniversalSearchResultsDTO: Codable, Sendable {
    public let query: String
    public let totalMatches: Int
    public let quotes: [DailyThoughtDTO]
    public let affirmations: [AffirmationDTO]
    public let packs: [RisePackDTO]
}
