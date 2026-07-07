import Foundation

struct ChaseEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var eventType: String
    var location: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), eventType: String = "", location: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.eventType = eventType
        self.location = location
        self.notes = notes
    }
}
