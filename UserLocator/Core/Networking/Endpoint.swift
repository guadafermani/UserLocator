struct Endpoint: Equatable, Sendable {
    let path: String
}

extension Endpoint {
    static let users = Endpoint(path: "/users")
}
