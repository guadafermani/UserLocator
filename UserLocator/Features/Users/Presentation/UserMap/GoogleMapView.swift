import GoogleMaps
import SwiftUI

struct GoogleMapView: UIViewRepresentable {
    private static let cameraZoom: Float = 14

    let coordinate: Coordinate
    let markerAccessibilityLabel: String

    func makeUIView(context: Context) -> GMSMapView {
        let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)

        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(target: position, zoom: Self.cameraZoom)

        let mapView = GMSMapView(options: options)

        let marker = GMSMarker(position: position)
        marker.accessibilityLabel = markerAccessibilityLabel
        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}
}
