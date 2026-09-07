import SwiftUI

struct UserMapView: View {
    private static let missingKeyIcon = "map"

    let viewModel: UserMapViewModel

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .navigationTitle(viewModel.title)
            .appBarStyle()
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case let .ready(coordinate):
            GoogleMapView(
                coordinate: coordinate,
                initials: viewModel.markerInitials,
                markerAccessibilityLabel: String(localized: "user_map.marker.accessibility_label \(viewModel.title)")
            )
            .ignoresSafeArea(edges: .bottom)

        case .missingAPIKey:
            StateView(
                icon: Self.missingKeyIcon,
                iconColor: AppColor.textSecondary,
                title: "user_map.missing_key.title",
                message: "user_map.missing_key.message"
            )
        }
    }
}
