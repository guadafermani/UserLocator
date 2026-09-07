struct LocatedUser: Hashable, Sendable {
    let name: String
    let username: String
    let address: Address?
    let coordinate: Coordinate
}

extension LocatedUser {
    init?(user: User) {
        guard let coordinate = user.coordinate else { return nil }

        self.init(
            name: user.name,
            username: user.username,
            address: user.address,
            coordinate: coordinate
        )
    }
}
