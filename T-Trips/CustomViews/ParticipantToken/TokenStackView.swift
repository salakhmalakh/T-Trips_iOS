import UIKit

final class TokenStackView: UIStackView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in arrangedSubviews where !view.isHidden && view.alpha > 0 {
            let local = convert(point, to: view)
            if view.point(inside: local, with: event) { return true }
        }
        return false
    }
}
