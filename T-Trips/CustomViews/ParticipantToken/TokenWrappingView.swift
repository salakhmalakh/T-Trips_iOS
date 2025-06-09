import UIKit

final class TokenWrappingView: UIView {
    var spacing: CGFloat = 4
    /// additional space reserved at the end of each line
    var trailingSpace: CGFloat = 0
    var onHeightChange: (() -> Void)?
    private var contentHeight: CGFloat = 0

    override func layoutSubviews() {
        super.layoutSubviews()
        let maxWidth = bounds.width - trailingSpace
        var origin = CGPoint(x: 0, y: 0)
        var rowHeight: CGFloat = 0

        for subview in subviews where !subview.isHidden && subview.alpha > 0 {
            let size = subview.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            if origin.x > 0 && origin.x + size.width > maxWidth {
                origin.x = 0
                origin.y += rowHeight + spacing
                rowHeight = 0
            }
            subview.frame = CGRect(origin: origin, size: size)
            origin.x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        let newHeight = origin.y + rowHeight
        if abs(newHeight - contentHeight) > 0.5 {
            contentHeight = newHeight
            invalidateIntrinsicContentSize()
            onHeightChange?()
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: contentHeight)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews where !view.isHidden && view.alpha > 0 {
            let local = convert(point, to: view)
            if view.point(inside: local, with: event) { return true }
        }
        return false
    }
}