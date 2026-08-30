import SwiftUI

// First screen: choose who is included in the bill.
struct PeopleSelectionView: View {

    @ObservedObject
    var store: SplitMateStore

    @Binding
    var path: [SplitMateRoute]

    @State
    private var newPersonName = ""

    var body: some View {

        ZStack {
            SplitMateTheme
                .backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {

                ScreenHeader(
                    title: "Housemates",
                    step: 1,
                    showsBackButton: false
                )

                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: 18
                    ) {

                        Text(
                            "Who's splitting this bill?"
                        )
                        .font(
                            .system(
                                size: 30,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            SplitMateTheme.textPrimary
                        )

                        Text(
                            "Select the housemates sharing this grocery bill."
                        )
                        .font(.system(size: 16))
                        .foregroundStyle(
                            SplitMateTheme.textSecondary
                        )

                        Text("TAP TO INCLUDE")
                            .font(
                                .system(
                                    size: 12,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(
                                SplitMateTheme.textSecondary
                            )

                        FlowLayout(spacing: 12) {
                            ForEach(store.people) { person in

                                PersonAvatar(
                                    person: person,
                                    isSelected:
                                        store
                                            .selectedHousemateIDs
                                            .contains(
                                                person.id
                                            )
                                ) {
                                    store.toggleHousemate(
                                        person
                                    )
                                }
                            }
                        }

                        Text(
                            "\(store.activePeople.count) people selected"
                        )
                        .font(
                            .system(
                                size: 13,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            SplitMateTheme.mint
                        )

                        addPersonCard
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
                title: "Continue",
                disabled:
                    store.activePeople.count < 2
            ) {
                path.append(.receipt)
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

    private var addPersonCard: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            Text("Add another person")
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )

            HStack(spacing: 10) {

                TextField(
                    "Name",
                    text: $newPersonName
                )
                .textInputAutocapitalization(
                    .words
                )
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(
                    SplitMateTheme.background
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .stroke(
                        SplitMateTheme.border
                    )
                }

                Button("Add") {

                    store.addPerson(
                        name: newPersonName
                    )

                    newPersonName = ""
                }
                .font(
                    .system(
                        size: 15,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    SplitMateTheme.plum
                )
                .frame(
                    width: 56,
                    height: 48
                )
                .background(
                    SplitMateTheme.selected
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
            }
        }
        .padding(18)
        .splitMateCard()
    }
}
