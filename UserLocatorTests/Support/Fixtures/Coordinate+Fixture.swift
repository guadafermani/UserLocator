@testable import UserLocator

extension Coordinate {
    static func fixture(
        latitude: Double = -37.3159,
        longitude: Double = 81.1496
    ) -> Coordinate {
        Coordinate(latitude: latitude, longitude: longitude)
    }
}
