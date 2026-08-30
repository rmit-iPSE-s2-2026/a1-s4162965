import Foundation

// One item entered from the receipt.
struct GroceryItem: Identifiable {
    let id: UUID

    var name: String
    var price: Double
    var quantity: Int

    // Keeps track of who shared this item.
    var assignedPersonIDs: Set<UUID>

    init(
        id: UUID = UUID(),
        name: String,
        price: Double,
        quantity: Int = 1,
        assignedPersonIDs: Set<UUID> = []
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.assignedPersonIDs =
            assignedPersonIDs
    }

    var totalPrice: Double {
        price * Double(quantity)
    }
}
