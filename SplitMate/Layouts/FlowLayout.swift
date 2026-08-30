import SwiftUI

/*
 FlowLayout is used for the housemate controls.

 The number of housemates can change and their names can have
 different widths. For example, "Hari" takes much less space
 than a longer name. The controls therefore need to move onto
 a new row when there is not enough horizontal space.

 A normal HStack cannot wrap views onto another row.

 I also considered LazyVGrid. It would adapt to screen width,
 but it arranges views into fixed columns. That is less suitable
 here because the housemate controls can have different widths.

 FlowLayout measures the available space and places as many views
 as possible on each row. When the next view does not fit, it
 starts another row.

 It needs more code than HStack or LazyVGrid, but it works better
 for this variable-width content and can be reused elsewhere.
 */

struct FlowLayout: Layout {

    var spacing: CGFloat = 12

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        let maxWidth =
            proposal.width ?? .infinity

        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widestRow: CGFloat = 0

        for subview in subviews {

            let size =
                subview.sizeThatFits(
                    .unspecified
                )

            // Move to a new row if this view does not fit.
            if
                currentX > 0,
                currentX
                    + spacing
                    + size.width
                    > maxWidth
            {
                widestRow =
                    max(
                        widestRow,
                        currentX
                    )

                currentY +=
                    rowHeight + spacing

                currentX = 0
                rowHeight = 0
            }

            if currentX > 0 {
                currentX += spacing
            }

            currentX += size.width

            rowHeight =
                max(
                    rowHeight,
                    size.height
                )
        }

        widestRow =
            max(
                widestRow,
                currentX
            )

        return CGSize(
            width:
                proposal.width
                ?? widestRow,
            height:
                currentY + rowHeight
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {

        var currentX =
            bounds.minX

        var currentY =
            bounds.minY

        var rowHeight: CGFloat = 0

        for subview in subviews {

            let size =
                subview.sizeThatFits(
                    .unspecified
                )

            if
                currentX > bounds.minX,
                currentX
                    + spacing
                    + size.width
                    > bounds.maxX
            {
                currentX =
                    bounds.minX

                currentY +=
                    rowHeight + spacing

                rowHeight = 0
            }

            if currentX > bounds.minX {
                currentX += spacing
            }

            subview.place(
                at: CGPoint(
                    x: currentX,
                    y: currentY
                ),
                anchor: .topLeading,
                proposal:
                    ProposedViewSize(
                        width: size.width,
                        height: size.height
                    )
            )

            currentX += size.width

            rowHeight =
                max(
                    rowHeight,
                    size.height
                )
        }
    }
}
