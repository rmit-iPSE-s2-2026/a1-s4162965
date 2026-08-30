import Foundation
import Combine

// Stores the bill data and handles the calculations.
final class SplitMateStore: ObservableObject {

    @Published var people: [Person]
    @Published var selectedHousemateIDs: Set<UUID>
    @Published var items: [GroceryItem] = []

    init() {
        let initialPeople = [
            Person(name: "Hari"),
            Person(name: "Kirthika"),
            Person(name: "Surya"),
            Person(name: "Ishu"),
            Person(name: "Jenny"),
            Person(name: "Karthi")
        ]

        people = initialPeople
        selectedHousemateIDs = Set(initialPeople.map(\.id))
    }

    // People included in the current bill.
    var activePeople: [Person] {
        people.filter {
            selectedHousemateIDs.contains($0.id)
        }
    }

    // Total value of all receipt items.
    var billTotal: Double {
        items.reduce(0) {
            $0 + $1.totalPrice
        }
    }

    var allItemsAssigned: Bool {
        !items.isEmpty &&
        items.allSatisfy {
            !$0.assignedPersonIDs.isEmpty
        }
    }

    // MARK: - Housemates

    func toggleHousemate(_ person: Person) {

        if selectedHousemateIDs.contains(person.id) {

            // Keep at least two people in the bill.
            guard selectedHousemateIDs.count > 2 else {
                return
            }

            selectedHousemateIDs.remove(person.id)

            // Remove them from existing item assignments too.
            for index in items.indices {

                items[index]
                    .assignedPersonIDs
                    .remove(person.id)

                if items[index]
                    .assignedPersonIDs
                    .isEmpty {

                    items[index]
                        .assignedPersonIDs =
                        selectedHousemateIDs
                }
            }

        } else {

            selectedHousemateIDs.insert(person.id)
        }
    }

    func addPerson(name: String) {

        let cleanName =
            name.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !cleanName.isEmpty else {
            return
        }

        let newPerson =
            Person(name: cleanName)

        people.append(newPerson)

        selectedHousemateIDs.insert(
            newPerson.id
        )
    }

    // MARK: - Items

    func addItem(
        name: String,
        price: Double,
        quantity: Int
    ) {

        let cleanName =
            name.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard
            !cleanName.isEmpty,
            price > 0,
            quantity > 0
        else {
            return
        }

        // New items start assigned to everyone in the bill.
        let item =
            GroceryItem(
                name: cleanName,
                price: price,
                quantity: quantity,
                assignedPersonIDs:
                    selectedHousemateIDs
            )

        items.append(item)
    }

    // MARK: - Assignments

    func toggleAssignment(
        itemID: UUID,
        personID: UUID
    ) {

        guard
            let index =
                items.firstIndex(
                    where: {
                        $0.id == itemID
                    }
                )
        else {
            return
        }

        if items[index]
            .assignedPersonIDs
            .contains(personID) {

            // Don't allow an item to have nobody assigned.
            guard
                items[index]
                    .assignedPersonIDs
                    .count > 1
            else {
                return
            }

            items[index]
                .assignedPersonIDs
                .remove(personID)

        } else {

            items[index]
                .assignedPersonIDs
                .insert(personID)
        }
    }

    func assignedPeople(
        for item: GroceryItem
    ) -> [Person] {

        people.filter {
            item
                .assignedPersonIDs
                .contains($0.id)
        }
    }

    // MARK: - Split calculation

    /*
     I use cents here so rounding stays accurate.

     Example:

     $18.75 = 1875 cents

     Split between 4 people:

     1875 / 4 = 468 cents with 3 cents left.

     The first three people get one extra cent:

     469 + 469 + 469 + 468 = 1875

     This means the final amounts always add up
     to the bill total.
     */
    func assignmentCents(
        for item: GroceryItem
    ) -> [UUID: Int] {

        let assigned =
            assignedPeople(for: item)

        guard !assigned.isEmpty else {
            return [:]
        }

        let totalCents =
            Int(
                (
                    item.totalPrice * 100
                ).rounded()
            )

        let count =
            assigned.count

        let baseAmount =
            totalCents / count

        let remainder =
            totalCents % count

        var result: [UUID: Int] = [:]

        for (index, person)
            in assigned.enumerated() {

            let extraCent =
                index < remainder
                ? 1
                : 0

            result[person.id] =
                baseAmount + extraCent
        }

        return result
    }

    func shareSummary(
        for item: GroceryItem
    ) -> String {

        let shares =
            assignmentCents(for: item)

        guard !shares.isEmpty else {
            return "No one selected"
        }

        let uniqueAmounts =
            Set(shares.values)

        // No rounding difference.
        if
            uniqueAmounts.count == 1,
            let cents =
                uniqueAmounts.first
        {
            return (
                Double(cents) / 100
            ).money + " each"
        }

        // Show an approximate value when one cent is left over.
        let average =
            item.totalPrice /
            Double(shares.count)

        return "≈ \(average.money) each"
    }

    func amountOwed(
        by person: Person
    ) -> Double {

        var cents = 0

        for item in items {

            let split =
                assignmentCents(
                    for: item
                )

            cents +=
                split[person.id] ?? 0
        }

        return Double(cents) / 100
    }

    // Clear the current bill and start again.
    func resetBill() {

        items.removeAll()

        selectedHousemateIDs =
            Set(people.map(\.id))
    }
}
