import SwiftUI

// Last screen: show how much everyone owes.
struct FinalAmountView: View {

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
                    title: "Final Amounts",
                    step: 5,
                    onBack: goBack
                )

                ScrollView {
                    VStack(spacing: 18) {

                        successMotif
                            .padding(.top, 20)

                        Text("Split Complete")
                            .font(
                                .system(
                                    size: 31,
                                    weight: .bold
                                )
                            )

                        Text(
                            "Here is what everyone owes."
                        )
                        .font(.system(size: 16))
                        .foregroundStyle(
                            SplitMateTheme.textSecondary
                        )

                        VStack(spacing: 10) {
                            ForEach(
                                store.activePeople
                            ) { person in

                                amountRow(person)
                            }
                        }
                        .padding(.top, 10)

                        Divider()

                        HStack {

                            Text("Bill Total")
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
                                    size: 20,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(
                                SplitMateTheme.plum
                            )
                        }

                        SecondaryButton(
                            title:
                                "Start another split"
                        ) {
                            store.resetBill()
                            path.removeAll()
                        }
                        .padding(.top, 14)
                    }
                    .padding(
                        .horizontal,
                        SplitMateTheme.horizontalPadding
                    )
                    .padding(.bottom, 30)
                }
            }
        }
        .toolbar(
            .hidden,
            for: .navigationBar
        )
    }

    private var successMotif: some View {

        ZStack {

            Circle()
                .fill(
                    SplitMateTheme.selected
                )
                .overlay {
                    Circle()
                        .stroke(
                            SplitMateTheme.primary,
                            lineWidth: 1.5
                        )
                }
                .frame(
                    width: 62,
                    height: 62
                )
                .offset(x: -13)

            Circle()
                .fill(
                    SplitMateTheme.mintSoft
                )
                .overlay {
                    Circle()
                        .stroke(
                            SplitMateTheme.mint,
                            lineWidth: 1.5
                        )
                }
                .frame(
                    width: 62,
                    height: 62
                )
                .offset(x: 13)

            Image(
                systemName: "checkmark"
            )
            .font(
                .system(
                    size: 28,
                    weight: .bold
                )
            )
            .foregroundStyle(
                SplitMateTheme.plum
            )
        }
        .frame(
            width: 90,
            height: 70
        )
    }

    private func amountRow(
        _ person: Person
    ) -> some View {

        let amount =
            store.amountOwed(
                by: person
            )

        return HStack(spacing: 12) {

            MiniPersonAvatar(
                person: person,
                isSelected: amount > 0
            )

            Text(person.name)
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )

            Spacer()

            Text(amount.money)
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
        .padding(.horizontal, 18)
        .frame(minHeight: 72)
        .splitMateCard(
            cornerRadius: 18
        )
    }

    private func goBack() {
        guard !path.isEmpty else {
            return
        }

        path.removeLast()
    }
}
