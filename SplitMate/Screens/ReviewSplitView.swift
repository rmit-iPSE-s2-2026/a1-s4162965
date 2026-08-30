import SwiftUI

// Fourth screen: check everything before confirming.
struct ReviewSplitView: View {

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
                    title: "Review",
                    step: 4,
                    onBack: goBack
                )

                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: 18
                    ) {

                        Text("Review split")
                            .font(
                                .system(
                                    size: 30,
                                    weight: .bold
                                )
                            )

                        Text(
                            "Check the items and housemates before confirming."
                        )
                        .font(.system(size: 16))
                        .foregroundStyle(
                            SplitMateTheme.textSecondary
                        )

                        ForEach(store.items) { item in
                            reviewCard(item)
                        }

                        HStack {

                            Text("Total")
                                .font(
                                    .system(
                                        size: 17,
                                        weight: .semibold
                                    )
                                )

                            Spacer()

                            Text(
                                store.billTotal.money
                            )
                            .font(
                                .system(
                                    size: 21,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(
                                SplitMateTheme.plum
                            )
                        }
                        .padding(.horizontal, 18)
                        .frame(height: 76)
                        .background(
                            SplitMateTheme.selected
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 18
                            )
                        )

                        SecondaryButton(
                            title:
                                "Edit assignments"
                        ) {
                            goBack()
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
                title: "Confirm Split"
            ) {
                path.append(.final)
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

    private func reviewCard(
        _ item: GroceryItem
    ) -> some View {

        let assigned =
            store.assignedPeople(
                for: item
            )

        return VStack(
            alignment: .leading,
            spacing: 14
        ) {

            HStack {

                Text(item.name)
                    .font(
                        .system(
                            size: 18,
                            weight: .semibold
                        )
                    )

                Spacer()

                Text(
                    item.totalPrice.money
                )
                .font(
                    .system(
                        size: 18,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    SplitMateTheme.plum
                )
            }

            FlowLayout(spacing: 8) {
                ForEach(assigned) { person in
                    MiniPersonAvatar(
                        person: person
                    )
                }
            }

            SplitSegments(
                people:
                    store.activePeople,
                selectedPersonIDs:
                    item.assignedPersonIDs
            )

            HStack {

                Text(
                    "\(assigned.count) \(assigned.count == 1 ? "person" : "people")"
                )
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    SplitMateTheme.textSecondary
                )

                Spacer()

                Text(
                    store.shareSummary(
                        for: item
                    )
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
            }
        }
        .padding(18)
        .splitMateCard(
            cornerRadius: 20
        )
    }

    private func goBack() {
        guard !path.isEmpty else {
            return
        }

        path.removeLast()
    }
}
