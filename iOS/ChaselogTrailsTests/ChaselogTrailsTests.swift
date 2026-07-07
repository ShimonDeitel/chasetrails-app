import XCTest
@testable import ChaselogTrails

@MainActor
final class ChaselogTrailsTests: XCTestCase {
    var store: Store!

    override func setUp() async throws {
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, Store.freeTierLimit)
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(ChaseEntry(eventType: "Test Entry"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddedEntryAppearsFirst() {
        store.add(ChaseEntry(eventType: "Newest"))
        XCTAssertEqual(store.entries.first?.eventType, "Newest")
    }

    func testDeleteRemovesEntry() {
        let entry = ChaseEntry(eventType: "ToDelete")
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(entry))
    }

    func testCanAddMoreWhenBelowLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtFreeLimitWithoutPro() {
        store.entries = (0..<Store.freeTierLimit).map { _ in ChaseEntry(eventType: "X") }
        XCTAssertFalse(store.canAddMore)
    }

    func testAddBlockedAtLimitDoesNotAppend() {
        store.entries = (0..<Store.freeTierLimit).map { _ in ChaseEntry(eventType: "X") }
        let before = store.entries.count
        store.add(ChaseEntry(eventType: "Overflow"))
        XCTAssertEqual(store.entries.count, before)
    }

    func testUpdateModifiesExistingEntry() {
        let entry = ChaseEntry(eventType: "Original")
        store.add(entry)
        var updated = entry
        updated.eventType = "Updated"
        store.update(updated)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.eventType, "Updated")
    }
}
