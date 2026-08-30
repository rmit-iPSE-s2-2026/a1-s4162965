import SwiftUI

// Main button used to move to the next screen.
struct PrimaryButton: View {
    let title: String
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    disabled
                    ? SplitMateTheme.textSecondary
                    : Color.white
                )
                .frame(maxWidth: .infinity)
                .frame(minHeight: 58)
                .background {
                    if disabled {
                        SplitMateTheme.progressInactive
                    } else {
                        SplitMateTheme.primaryGradient
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}


// Used for less important actions.
struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    SplitMateTheme.plum
                )
                .frame(maxWidth: .infinity)
                .frame(minHeight: 58)
                .background(
                    SplitMateTheme.white
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 18,
                        style: .continuous
                    )
                    .stroke(
                        SplitMateTheme.border,
                        lineWidth: 1
                    )
                }
        }
        .buttonStyle(.plain)
    }
}
