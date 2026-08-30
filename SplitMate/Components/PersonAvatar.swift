import SwiftUI

// Shows a housemate as an avatar.
struct PersonAvatar: View {
    let person: Person
    let isSelected: Bool
    let action: () -> Void

    private var initial: String {
        String(person.name.prefix(1)).uppercased()
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {

                ZStack(alignment: .bottomTrailing) {

                    ZStack {
                        Circle()
                            .fill(
                                isSelected
                                ? SplitMateTheme.selected
                                : SplitMateTheme.white
                            )

                        Circle()
                            .stroke(
                                isSelected
                                ? SplitMateTheme.primary
                                : SplitMateTheme.border,
                                lineWidth: isSelected ? 2 : 1
                            )

                        Text(initial)
                            .font(
                                .system(
                                    size: 20,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(
                                isSelected
                                ? SplitMateTheme.plum
                                : SplitMateTheme.textSecondary
                            )
                    }
                    .frame(width: 56, height: 56)

                    // Checkmark for selected people.
                    if isSelected {
                        ZStack {
                            Circle()
                                .fill(SplitMateTheme.primary)

                            Image(systemName: "checkmark")
                                .font(
                                    .system(
                                        size: 10,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(
                                    SplitMateTheme.plum
                                )
                        }
                        .frame(width: 20, height: 20)
                        .offset(x: 3, y: 3)
                    }
                }

                Text(person.name)
                    .font(
                        .system(
                            size: 13,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        isSelected
                        ? SplitMateTheme.textPrimary
                        : SplitMateTheme.textSecondary
                    )
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 72)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(person.name)
        .accessibilityValue(
            isSelected ? "Selected" : "Not selected"
        )
    }
}


// Smaller avatar used on summary screens.
struct MiniPersonAvatar: View {
    let person: Person
    var isSelected: Bool = true

    private var initial: String {
        String(person.name.prefix(1)).uppercased()
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    isSelected
                    ? SplitMateTheme.selected
                    : SplitMateTheme.progressInactive
                )

            Circle()
                .stroke(
                    isSelected
                    ? SplitMateTheme.primary
                    : SplitMateTheme.border,
                    lineWidth: 1.5
                )

            Text(initial)
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    SplitMateTheme.plum
                )
        }
        .frame(width: 40, height: 40)
    }
}
