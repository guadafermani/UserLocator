import GoogleMaps
import SwiftUI

struct GoogleMapView: UIViewRepresentable {
    private static let cameraZoom: Float = 2

    let coordinate: Coordinate
    let initials: String?
    let markerAccessibilityLabel: String

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) private var displayScale

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> GMSMapView {
        let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)

        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(target: position, zoom: Self.cameraZoom)

        let mapView = GMSMapView(options: options)

        let marker = GMSMarker(position: position)
        marker.accessibilityLabel = markerAccessibilityLabel
        marker.groundAnchor = MarkerIconFactory.groundAnchor
        marker.map = mapView
        context.coordinator.marker = marker

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        let traits = makeTraits()

        uiView.overrideUserInterfaceStyle = traits.userInterfaceStyle
        context.coordinator.marker?.icon = MarkerIconFactory.makeIcon(initials: initials, traits: traits)
    }

    private func makeTraits() -> UITraitCollection {
        UITraitCollection { traits in
            traits.userInterfaceStyle = colorScheme == .dark ? .dark : .light
            traits.displayScale = displayScale
        }
    }

    @MainActor
    final class Coordinator {
        var marker: GMSMarker?
    }
}
