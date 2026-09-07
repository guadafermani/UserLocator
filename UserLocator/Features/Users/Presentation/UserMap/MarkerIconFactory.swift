import UIKit

enum MarkerIconFactory {
    static let groundAnchor = CGPoint(x: 0.5, y: 1)

    private static let size = CGSize(width: 40, height: 50)
    private static let circleDiameter: CGFloat = 28

    static func makeIcon(initials: String?, traits: UITraitCollection) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size, format: UIGraphicsImageRendererFormat(for: traits))

        return renderer.image { _ in
            AppColor.accent.uiColor.resolvedColor(with: traits).setFill()
            makeTeardropPath().fill()

            AppColor.surface.uiColor.resolvedColor(with: traits).setFill()
            UIBezierPath(ovalIn: circleRect).fill()

            guard let initials else { return }
            makeInitialsText(initials, traits: traits).draw(at: origin(of: initials, traits: traits))
        }
    }

    private static var circleRect: CGRect {
        CGRect(
            x: (size.width - circleDiameter) / 2,
            y: (size.width - circleDiameter) / 2,
            width: circleDiameter,
            height: circleDiameter
        )
    }

    private static func makeTeardropPath() -> UIBezierPath {
        let radius = size.width / 2
        let centre = CGPoint(x: radius, y: radius)
        let tip = CGPoint(x: radius, y: size.height)
        let tangentAngle = acos(radius / (tip.y - centre.y))

        let path = UIBezierPath()
        path.addArc(
            withCenter: centre,
            radius: radius,
            startAngle: .pi / 2 + tangentAngle,
            endAngle: .pi / 2 - tangentAngle,
            clockwise: true
        )
        path.addLine(to: tip)
        path.close()

        return path
    }

    private static func makeInitialsText(_ initials: String, traits: UITraitCollection) -> NSAttributedString {
        var attributes = AttributeContainer()
        attributes.uiKit.font = AppTypography.markerInitials
        attributes.uiKit.foregroundColor = AppColor.accent.uiColor.resolvedColor(with: traits)

        return NSAttributedString(AttributedString(initials, attributes: attributes))
    }

    private static func origin(of initials: String, traits: UITraitCollection) -> CGPoint {
        let textSize = makeInitialsText(initials, traits: traits).size()

        return CGPoint(x: circleRect.midX - textSize.width / 2, y: circleRect.midY - textSize.height / 2)
    }
}
