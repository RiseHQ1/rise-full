//
//  NotificationServiceProtocol.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Protocol for scheduling and managing local notifications.
public protocol NotificationServiceProtocol: Sendable {
    func requestAuthorization() async throws -> Bool
    func scheduleDailyReminder(at time: Date, title: String, body: String) async throws
    func cancelAllReminders() async
}
