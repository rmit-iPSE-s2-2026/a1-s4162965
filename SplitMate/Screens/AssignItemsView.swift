import SwiftUI

// Third screen: choose who shared each item.
struct AssignItemsView: View {

    @ObservedObject
    var store: SplitMateStore

    @Binding
    var path: [SplitMateRoute]

    var body: some View {

        ZStack {
            SplitMateTheme
                .backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {

                ScreenHeader(
                    title: "Assign Items",
                    step: 3,
                    onBack: goBack
                )

                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: 18
                    ) {

                        Text("Assign each item")
                            .font(
                                .system(
                                    size: 30,
                                    weight: .bold
                                )
                            )

                        Text(
                            "Choose who shared each grocery item."
                        )
                        .font(.system(size: 16))
                        .foregroundStyle(
                            SplitMateTheme.textSecondary
                        )

                        ForEach(store.items) { item in
                            assignmentCard(item)
                        }

                        if store.allItemsAssigned {
                            Text(
                                "✓ Every item has someone assigned"
                            )
                            .font(
                                .system(
                                    size: 13,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(
                                SplitMateTheme.mint
                            )
                        }
                    }
                    .padding(
                        .horizontal,
                        SplitMateTheme.horizontalPadding
                    )
                    .padding(.top, 20)
                    .padding(.bottom, 110)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {

            PrimaryButton(
                title: "Review Split",
                disabled:
                    !store.allItemsAssigned
            ) {
                path.append(.review)
            }
            .padding(
                .horizontal,
                SplitMateTheme.horizontalPadding
            )
            .padding(.vertical, 10)
            .background(
                SplitMateTheme.background
            )
        }
        .toolbar(
            .hidden,
            for: .navigationBar
        )
    }

    private func assignmentCard(
        _ item: GroceryItem
    ) -> some View {

        let selectedCount =
            item.assignedPersonIDs.count

        return VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                VStack(
                    alignment: .leading,
                    spacing: 3
                ) {

                    Text(item.name)
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                    Text(
                        item.totalPrice.money
                    )
                    .font(.system(size: 15))
                    .foregroundStyle(
                        SplitMateTheme.textSecondary
                    )
                }

                Spacer()

                Text(
                    "\(selectedCount) selected"
                )
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    SplitMateTheme.plum
                )
                .padding(
                    .horizontal,
                    12
                )
                .frame(height: 30)
                .background(
                    SplitMateTheme.selected
                )
                .clipShape(Capsule())
            }

            FlowLayout(spacing: 12) {
                ForEach(
                    store.activePeople
                ) { person in

                    PersonAvatar(
                        person: person,
                        isSelected:
                            item
                                .assignedPersonIDs
                                .contains(
                                    person.id
                                )
                    ) {
                        store.toggleAssignment(
                            itemID: item.id,
                            personID: person.id
                        )
                    }
                }
            }

            Text("EQUAL SPLIT")
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    SplitMateTheme.textSecondary
                )

            SplitSegments(
                people:
                    store.activePeople,
                selectedPersonIDs:
                    item.assignedPersonIDs
            )

            Text(
                "= \(store.shareSummary(for: item))"
            )
            .font(
                .system(
                    size: 14,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                SplitMateTheme.plum
            )
            .padding(
                .horizontal,
                14
            )
            .frame(height: 42)
            .background(
                SplitMateTheme.mintSoft
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )

            Text(
                "Selected avatars are the people sharing this item."
            )
            .font(.system(size: 12))
            .foregroundStyle(
                SplitMateTheme.textSecondary
            )
        }
        .padding(18)
        .splitMateCard(
            cornerRadius: 22
        )
    }

    private func goBack() {
        guard !path.isEmpty else {
            return
        }

        path.removeLast()
    }
}
