import SwiftUI

// Small bars showing who is sharing an item.
struct SplitSegments: View {
    let people: [Person]
    let selectedPersonIDs: Set<UUID>

    var body: some View {
        HStack(spacing: 12) {
            ForEach(people) { person in
                Capsule()
                    .fill(
                        selectedPersonIDs.contains(
                            person.id
                        )
                        ? SplitMateTheme.primary
                        : SplitMateTheme.progressInactive
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 8)
            }
        }
        .accessibilityHidden(true)
    }
}
