struct User: Equatable, Sendable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let address: Address?
    let coordinate: Coordinate?
}
