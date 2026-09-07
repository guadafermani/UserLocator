import UIKit

extension UIColor {
    func isApproximately(_ other: UIColor, tolerance: CGFloat = 0.01) -> Bool {
        let lhs = CIColor(color: self)
        let rhs = CIColor(color: other)

        return abs(lhs.red - rhs.red) <= tolerance
            && abs(lhs.green - rhs.green) <= tolerance
            && abs(lhs.blue - rhs.blue) <= tolerance
            && abs(lhs.alpha - rhs.alpha) <= tolerance
    }
}
