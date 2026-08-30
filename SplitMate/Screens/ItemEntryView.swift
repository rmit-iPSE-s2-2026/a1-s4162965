import SwiftUI

// Second screen: enter the receipt items.
struct ItemEntryView: View {

    @ObservedObject
    var store: SplitMateStore

    @Binding
    var path: [SplitMateRoute]

    @State private var itemName = ""
    @State private var priceText = ""
    @State private var quantity = 1
    @State private var showInvalidAlert = false

    @FocusState
    private var focusedField: Field?

    private enum Field {
        case itemName
        case price
    }

    var body: some View {

        ZStack {
            SplitMateTheme
                .backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {

                ScreenHeader(
                    title: "Receipt Entry",
                    step: 2,
                    onBack: goBack
                )

                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: 18
                    ) {

                        Text("Enter grocery items")
                            .font(
                                .system(
                                    size: 30,
                                    weight: .bold
                                )
                            )

                        Text(
                            "Add items manually from your receipt."
                        )
                        .font(.system(size: 16))
                        .foregroundStyle(
                            SplitMateTheme.textSecondary
                        )

                        entryCard

                        if !store.items.isEmpty {

                            Text("RECEIPT ITEMS")
                                .font(
                                    .system(
                                        size: 12,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(
                                    SplitMateTheme.textSecondary
                                )

                            ForEach(store.items) { item in
                                receiptRow(item)
                            }

                            totalCard

                        } else {

                            Text("NO ITEMS YET")
                                .font(
                                    .system(
                                        size: 12,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(
                                    SplitMateTheme.textSecondary
                                )

                            Text(
                                "Add an item to continue."
                            )
                            .font(.system(size: 13))
                            .foregroundStyle(
                                SplitMateTheme.textSecondary
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
                title: "Continue",
                disabled: store.items.isEmpty
            ) {
                path.append(.assign)
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
        .alert(
            "Check item details",
            isPresented:
                $showInvalidAlert
        ) {
            Button(
                "OK",
                role: .cancel
            ) {}
        } message: {
            Text(
                "Enter an item name and a valid price greater than zero."
            )
        }
        .toolbar {
            ToolbarItemGroup(
                placement: .keyboard
            ) {
                Spacer()

                Button("Done") {
                    focusedField = nil
                }
            }
        }
        .toolbar(
            .hidden,
            for: .navigationBar
        )
    }

    private var entryCard: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            fieldLabel("Item name")

            TextField(
                "Item name",
                text: $itemName
            )
            .focused(
                $focusedField,
                equals: .itemName
            )
            .submitLabel(.next)
            .onSubmit {
                focusedField = .price
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
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

            fieldLabel("Price")

            TextField(
                "Price",
                text: $priceText
            )
            .focused(
                $focusedField,
                equals: .price
            )
            .keyboardType(.decimalPad)
            .padding(.horizontal, 14)
            .frame(height: 50)
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

            HStack {

                Text("Quantity")
                    .font(
                        .system(
                            size: 16,
                            weight: .medium
                        )
                    )

                Spacer()

                HStack(spacing: 18) {

                    Button {
                        quantity =
                            max(
                                1,
                                quantity - 1
                            )
                    } label: {
                        Image(
                            systemName: "minus"
                        )
                    }

                    Text("\(quantity)")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )

                    Button {
                        quantity += 1
                    } label: {
                        Image(
                            systemName: "plus"
                        )
                    }
                }
                .foregroundStyle(
                    SplitMateTheme.plum
                )
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(
                    SplitMateTheme.progressInactive
                )
                .clipShape(Capsule())
            }

            Button {
                addItem()
            } label: {
                Text("+  Add Item")
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        SplitMateTheme.plum
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(
                        SplitMateTheme.selected
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .splitMateCard(
            cornerRadius: 22
        )
    }

    private func fieldLabel(
        _ title: String
    ) -> some View {

        Text(title)
            .font(
                .system(
                    size: 13,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                SplitMateTheme.textSecondary
            )
    }

    private func receiptRow(
        _ item: GroceryItem
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            HStack {
                Text(item.name)
                    .font(
                        .system(
                            size: 17,
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

            Divider()

            Text(
                "Quantity: \(item.quantity)"
            )
            .font(.system(size: 12))
            .foregroundStyle(
                SplitMateTheme.textSecondary
            )
        }
        .padding(18)
        .splitMateCard(
            cornerRadius: 16
        )
        .overlay(
            alignment: .leading
        ) {
            Rectangle()
                .fill(
                    SplitMateTheme.primary
                )
                .frame(width: 4)
        }
    }

    private var totalCard: some View {

        HStack {

            Text("Receipt Total")
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )

            Spacer()

            Text(store.billTotal.money)
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
        .frame(height: 54)
        .background(
            SplitMateTheme.selected
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }

    private func addItem() {

        let cleanedPrice =
            priceText
                .replacingOccurrences(
                    of: "$",
                    with: ""
                )
                .replacingOccurrences(
                    of: ",",
                    with: ""
                )

        guard
            let price =
                Double(cleanedPrice),
            price > 0,
            !itemName
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .isEmpty
        else {
            showInvalidAlert = true
            return
        }

        store.addItem(
            name: itemName,
            price: price,
            quantity: quantity
        )

        itemName = ""
        priceText = ""
        quantity = 1
        focusedField = nil
    }

    private func goBack() {
        guard !path.isEmpty else {
            return
        }

        path.removeLast()
    }
}
