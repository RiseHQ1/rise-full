//
//  RiseError.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation

/// Typed domain and infrastructure error hierarchy for Rise.
public enum RiseError: LocalizedError, Equatable {
    case notFound(String)
    case persistenceFailure(String)
    case invalidData(String)
    case serviceUnavailable(String)
    case unauthorized
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case let .notFound(item):
            return "Item not found: \(item)"
        case let .persistenceFailure(message):
            return "Data storage error: \(message)"
        case let .invalidData(message):
            return "Invalid data format: \(message)"
        case let .serviceUnavailable(service):
            return "\(service) service is currently unavailable."
        case .unauthorized:
            return "Unauthorized access."
        case let .unknown(message):
            return "An unexpected error occurred: \(message)"
        }
    }
}
