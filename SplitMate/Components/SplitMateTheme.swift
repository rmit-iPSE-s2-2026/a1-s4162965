import SwiftUI
import Foundation

// Colours and spacing used across SplitMate.
enum SplitMateTheme {

    static let primary =
        Color(hex: "#DF00FF")

    static let plum =
        Color(hex: "#51005D")

    static let textPrimary =
        Color(hex: "#171318")

    static let textSecondary =
        Color(hex: "#7C747E")

    static let background =
        Color(hex: "#FFF9FF")

    static let selected =
        Color(hex: "#F8D9FC")

    static let progressInactive =
        Color(hex: "#F4EDF6")

    static let border =
        Color(hex: "#E8DDEB")

    static let mint =
        Color(hex: "#20C997")

    static let mintSoft =
        Color(hex: "#E5FAF3")

    static let white =
        Color.white

    static let horizontalPadding:
        CGFloat = 24

    static let primaryGradient =
        LinearGradient(
            colors: [
                Color(hex: "#DF00FF"),
                Color(hex: "#A100B8")
            ],
            startPoint: .leading,
            endPoint: .trailing
        )

    static let backgroundGradient =
        LinearGradient(
            colors: [
                Color(hex: "#FFF9FF"),
                Color(hex: "#FCEBFF")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
}


// Lets me use the same hex colours as the Figma design.
extension Color {
    init(hex: String) {
        let cleaned =
            hex.trimmingCharacters(
                in:
                    CharacterSet
                        .alphanumerics
                        .inverted
            )

        var value: UInt64 = 0

        Scanner(string: cleaned)
            .scanHexInt64(&value)

        let red =
            Double(
                (value >> 16) & 0xFF
            ) / 255

        let green =
            Double(
                (value >> 8) & 0xFF
            ) / 255

        let blue =
            Double(
                value & 0xFF
            ) / 255

        self.init(
            red: red,
            green: green,
            blue: blue
        )
    }
}


// Used to display prices the same way everywhere.
extension Double {
    var money: String {
        String(
            format: "$%.2f",
            self
        )
    }
}


// Common card style used on different screens.
extension View {
    func splitMateCard(
        cornerRadius: CGFloat = 20
    ) -> some View {

        self
            .background(
                SplitMateTheme.white
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
                .stroke(
                    SplitMateTheme.border,
                    lineWidth: 1
                )
            }
            .shadow(
                color:
                    SplitMateTheme.plum.opacity(0.06),
                radius: 14,
                x: 0,
                y: 5
            )
    }
}
