//
//  DependencyContainer.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Lightweight dependency container providing protocol-oriented services and repositories.
public final class DependencyContainer: @unchecked Sendable {
    // MARK: - Services

    public let contentService: ContentServiceProtocol
    public let notificationService: NotificationServiceProtocol
    public let audioService: AudioServiceProtocol
    public let hapticService: HapticServiceProtocol
    public let analyticsService: AnalyticsServiceProtocol

    // MARK: - Repositories & Persistence

    public let contentRepository: ContentRepositoryProtocol
    public let userProfileRepository: UserProfileRepositoryProtocol
    public let persistenceController: PersistenceController

    public init(
        contentService: ContentServiceProtocol,
        notificationService: NotificationServiceProtocol,
        audioService: AudioServiceProtocol,
        hapticService: HapticServiceProtocol,
        analyticsService: AnalyticsServiceProtocol,
        contentRepository: ContentRepositoryProtocol,
        userProfileRepository: UserProfileRepositoryProtocol,
        persistenceController: PersistenceController
    ) {
        self.contentService = contentService
        self.notificationService = notificationService
        self.audioService = audioService
        self.hapticService = hapticService
        self.analyticsService = analyticsService
        self.contentRepository = contentRepository
        self.userProfileRepository = userProfileRepository
        self.persistenceController = persistenceController
    }

    /// Production dependency container configured with default implementations.
    public static func live() -> DependencyContainer {
        let contentRepo = DefaultContentRepository()
        let userRepo = DefaultUserProfileRepository()
        let persistence = PersistenceController.shared

        return DependencyContainer(
            contentService: ContentService(contentRepository: contentRepo),
            notificationService: NotificationService(),
            audioService: AudioService(),
            hapticService: HapticService(),
            analyticsService: AnalyticsService(),
            contentRepository: contentRepo,
            userProfileRepository: userRepo,
            persistenceController: persistence
        )
    }

    /// Mock dependency container configured for SwiftUI Previews and Unit Tests.
    public static func mock() -> DependencyContainer {
        let contentRepo = DefaultContentRepository()
        let userRepo = DefaultUserProfileRepository()
        let persistence = PersistenceController.preview

        return DependencyContainer(
            contentService: ContentService(contentRepository: contentRepo),
            notificationService: NotificationService(),
            audioService: AudioService(),
            hapticService: HapticService(),
            analyticsService: AnalyticsService(),
            contentRepository: contentRepo,
            userProfileRepository: userRepo,
            persistenceController: persistence
        )
    }
}

// MARK: - SwiftUI Environment Integration

private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer = .live()
}

public extension EnvironmentValues {
    var dependencyContainer: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
