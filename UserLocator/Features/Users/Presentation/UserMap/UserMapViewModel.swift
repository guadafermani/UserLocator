import Observation

@MainActor
@Observable
final class UserMapViewModel {
    let title: String
    let state: UserMapState

    init(name: String, coordinate: Coordinate, isMapAvailable: Bool) {
        title = name
        state = isMapAvailable ? .ready(coordinate) : .missingAPIKey
    }
}
