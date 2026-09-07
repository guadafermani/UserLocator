import Testing
import UIKit
@testable import UserLocator

@MainActor
@Suite("MarkerIconFactory")
struct MarkerIconFactoryTests {

    @Test(arguments: [CGFloat(1), 2, 3])
    func whenRenderingForADisplayScale_rasterisesAtThatScale(displayScale: CGFloat) {
        let icon = MarkerIconFactory.makeIcon(initials: "LG", traits: makeTraits(displayScale: displayScale))

        #expect(icon.scale == displayScale)
    }

    @Test
    func whenRendering_paintsTheTipAtTheBottomCentre() throws {
        let icon = MarkerIconFactory.makeIcon(initials: "LG", traits: makeTraits())

        let tip = try #require(icon.pixelColor(at: CGPoint(x: icon.size.width / 2, y: icon.size.height - 1)))

        #expect(tip.cgColor.alpha > 0)
    }

    @Test(arguments: [0.05, 0.95])
    func whenRendering_leavesTheBottomCornersTransparent(horizontalPosition: CGFloat) throws {
        let icon = MarkerIconFactory.makeIcon(initials: "LG", traits: makeTraits())

        let corner = try #require(
            icon.pixelColor(at: CGPoint(x: icon.size.width * horizontalPosition, y: icon.size.height - 1))
        )

        #expect(corner.cgColor.alpha == 0)
    }

    @Test
    func whenRendering_paintsTheBodyWithTheAccent() throws {
        let traits = makeTraits()
        let icon = MarkerIconFactory.makeIcon(initials: "LG", traits: traits)

        let body = try #require(icon.pixelColor(at: CGPoint(x: icon.size.width / 2, y: icon.size.height * 0.05)))

        #expect(body.isApproximately(AppColor.accent.uiColor.resolvedColor(with: traits)))
    }

    @Test(arguments: [UIUserInterfaceStyle.light, .dark])
    func whenRendering_paintsTheCircleWithTheSurfaceOfTheAppearance(style: UIUserInterfaceStyle) throws {
        let traits = makeTraits(style: style)
        let icon = MarkerIconFactory.makeIcon(initials: nil, traits: traits)

        let circle = try #require(icon.pixelColor(at: CGPoint(x: icon.size.width / 2, y: icon.size.width / 2)))

        #expect(circle.isApproximately(AppColor.surface.uiColor.resolvedColor(with: traits)))
    }

    @Test
    func whenInitialsArePresent_drawsThemOverTheEmptyIcon() {
        let traits = makeTraits()

        let withInitials = MarkerIconFactory.makeIcon(initials: "LG", traits: traits)
        let withoutInitials = MarkerIconFactory.makeIcon(initials: nil, traits: traits)

        #expect(withInitials.pngData() != withoutInitials.pngData())
    }

    private func makeTraits(
        style: UIUserInterfaceStyle = .light,
        displayScale: CGFloat = 3
    ) -> UITraitCollection {
        UITraitCollection { traits in
            traits.userInterfaceStyle = style
            traits.displayScale = displayScale
        }
    }
}
