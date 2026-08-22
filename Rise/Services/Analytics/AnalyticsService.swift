//
//  AnalyticsService.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation
import os

/// Concrete implementation of AnalyticsServiceProtocol using structured logging.
public final class AnalyticsService: AnalyticsServiceProtocol, @unchecked Sendable {
    public init() {}
    
    public func track(event: String, parameters: [String: Any]? = nil) {
        AppLogger.services.info("Track event: \(event, privacy: .public), params: \(String(describing: parameters), privacy: .private)")
    }
    
    public func trackScreen(name: String) {
        AppLogger.navigation.info("Screen viewed: \(name, privacy: .public)")
    }
}
