import SwiftUI

struct UserMapView: View {
    private static let missingKeyIcon = "map"
    private static let cardMaximumHeightRatio: CGFloat = 1.0 / 3

    let viewModel: UserMapViewModel

    @State private var cardContentHeight: CGFloat = 0

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .navigationTitle(Text("user_map.title"))
            .appBarStyle()
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case let .ready(coordinate):
            map(centeredOn: coordinate)

        case .missingAPIKey:
            StateView(
                icon: Self.missingKeyIcon,
                iconColor: AppColor.textSecondary,
                title: "user_map.missing_key.title",
                message: "user_map.missing_key.message"
            )
        }
    }

    private func map(centeredOn coordinate: Coordinate) -> some View {
        GeometryReader { proxy in
            let cardHeight = min(cardContentHeight, proxy.size.height * Self.cardMaximumHeightRatio)

            GoogleMapView(
                coordinate: coordinate,
                initials: viewModel.markerInitials,
                markerAccessibilityLabel: markerAccessibilityLabel,
                bottomInset: cardHeight
            )
            .ignoresSafeArea(edges: [.horizontal, .bottom])
            .safeAreaInset(edge: .bottom, spacing: 0) {
                card(height: cardHeight)
            }
        }
    }

    private var markerAccessibilityLabel: String {
        String(localized: "user_map.marker.accessibility_label \(viewModel.card.name)")
    }

    private func card(height: CGFloat) -> some View {
        ScrollView {
            UserCardView(card: viewModel.card)
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .onChange(of: proxy.size.height, initial: true) { _, contentHeight in
                                cardContentHeight = contentHeight
                            }
                    }
                }
        }
        .scrollBounceBehavior(.basedOnSize)
        .frame(height: height)
        .background { surface }
    }

    private var surface: some View {
        UnevenRoundedRectangle(
            topLeadingRadius: AppRadius.large,
            topTrailingRadius: AppRadius.large
        )
        .fill(AppColor.surface)
        .shadow(color: AppColor.shadow.color, radius: AppElevation.cardBlur, y: AppElevation.cardOffsetY)
        .ignoresSafeArea(edges: [.horizontal, .bottom])
    }
}
