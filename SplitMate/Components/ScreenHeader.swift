import SwiftUI

// Header shared by all five screens.
struct ScreenHeader: View {
    let title: String
    let step: Int

    var showsBackButton: Bool = true
    var onBack: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 10) {

            ZStack {
                Text(title)
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        SplitMateTheme.textPrimary
                    )

                HStack {
                    if showsBackButton {
                        Button {
                            onBack?()
                        } label: {
                            Image(
                                systemName: "chevron.left"
                            )
                            .font(
                                .system(
                                    size: 20,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(
                                SplitMateTheme.textPrimary
                            )
                            .frame(
                                width: 46,
                                height: 46
                            )
                            .background(
                                SplitMateTheme.white
                            )
                            .clipShape(Circle())
                            .shadow(
                                color:
                                    SplitMateTheme.plum.opacity(0.08),
                                radius: 10,
                                y: 3
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Back")
                    }

                    Spacer()
                }
            }
            .frame(minHeight: 46)

            ProgressIndicator(
                currentStep: step
            )
        }
        .padding(
            .horizontal,
            SplitMateTheme.horizontalPadding
        )
        .padding(.top, 6)
    }
}
