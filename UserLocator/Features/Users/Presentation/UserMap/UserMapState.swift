enum UserMapState: Equatable {
    case ready(Coordinate)
    case missingAPIKey
}
