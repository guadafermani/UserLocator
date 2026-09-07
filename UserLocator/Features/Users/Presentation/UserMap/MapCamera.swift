import GoogleMaps

enum MapCamera {
    static let zoom: Float = 2

    static func initial(at coordinate: Coordinate) -> GMSCameraPosition {
        GMSCameraPosition(
            target: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
            zoom: zoom,
            bearing: 0,
            viewingAngle: 0
        )
    }
}
