import Foundation

// One housemate in the bill.
struct Person: Identifiable, Hashable {
    let id: UUID
    var name: String

    init(
        id: UUID = UUID(),
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
