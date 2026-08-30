import SwiftUI

// Sets up the shared data and navigation.
struct ContentView: View {

    @StateObject
    private var store =
        SplitMateStore()

    @State
    private var path:
        [SplitMateRoute] = []

    var body: some View {

        NavigationStack(
            path: $path
        ) {

            PeopleSelectionView(
                store: store,
                path: $path
            )
            .navigationDestination(
                for: SplitMateRoute.self
            ) { route in

                switch route {

                case .receipt:
                    ItemEntryView(
                        store: store,
                        path: $path
                    )

                case .assign:
                    AssignItemsView(
                        store: store,
                        path: $path
                    )

                case .review:
                    ReviewSplitView(
                        store: store,
                        path: $path
                    )

                case .final:
                    FinalAmountView(
                        store: store,
                        path: $path
                    )
                }
            }
        }
        .tint(
            SplitMateTheme.plum
        )
    }
}

#Preview {
    ContentView()
}
