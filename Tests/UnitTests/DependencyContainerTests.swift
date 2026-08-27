//
//  DependencyContainerTests.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

@testable import Rise
import Testing

@Suite("DependencyContainer Tests")
struct DependencyContainerTests {
    @Test("Live container initializes all dependencies")
    func liveContainer() {
        let container = DependencyContainer.live()
        #expect(container.persistenceController.inMemory == false)
    }

    @Test("Mock container initializes in-memory dependencies")
    func mockContainer() {
        let container = DependencyContainer.mock()
        #expect(container.persistenceController.inMemory == true)
    }
}
