//
//  PersistenceController.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Foundation
import SwiftData

/// Foundation for SwiftData persistence layer.
/// Configured to manage ModelContainer initialization and schema migrations in future phases.
public final class PersistenceController: @unchecked Sendable {
    public static let shared = PersistenceController(inMemory: false)
    public static let preview = PersistenceController(inMemory: true)
    
    public let inMemory: Bool
    
    public init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
}
