import Observation

@MainActor
@Observable
final class UserMapViewModel {
    let title: String
    let markerInitials: String?
    let state: UserMapState

    init(name: String, coordinate: Coordinate, isMapAvailable: Bool) {
        title = name
        markerInitials = InitialsFormatter.initials(from: name)
        state = isMapAvailable ? .ready(coordinate) : .missingAPIKey
    }
}
