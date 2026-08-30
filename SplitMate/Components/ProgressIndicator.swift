import SwiftUI

// Shows which of the five steps the user is on.
struct ProgressIndicator: View {
    let currentStep: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(1...5, id: \.self) { step in
                Capsule()
                    .fill(
                        step <= currentStep
                        ? SplitMateTheme.primary
                        : SplitMateTheme.progressInactive
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 4)
            }
        }
        .accessibilityLabel(
            "Step \(currentStep) of 5"
        )
    }
}
