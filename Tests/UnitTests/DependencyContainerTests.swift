//
//  DependencyContainerTests.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Testing
@testable import Rise

@Suite("DependencyContainer Tests")
struct DependencyContainerTests {
    @Test("Live container initializes all dependencies")
    func testLiveContainer() {
        let container = DependencyContainer.live()
        #expect(container.persistenceController.inMemory == false)
    }
    
    @Test("Mock container initializes in-memory dependencies")
    func testMockContainer() {
        let container = DependencyContainer.mock()
        #expect(container.persistenceController.inMemory == true)
    }
}
