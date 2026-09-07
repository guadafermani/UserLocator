enum UsersError: Error, Equatable, CaseIterable {
    case network
    case server
    case decoding
    case unknown
}
