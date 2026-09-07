import Observation

@MainActor
@Observable
final class UserMapViewModel {
    private static let streetSeparator = ", "
    private static let citySeparator = " "

    let card: UserCard
    let markerInitials: String?
    let state: UserMapState

    init(user: LocatedUser, isMapAvailable: Bool) {
        card = UserCard(
            name: user.name,
            username: user.username,
            addressLines: Self.addressLines(of: user.address)
        )
        markerInitials = InitialsFormatter.initials(from: user.name)
        state = isMapAvailable ? .ready(user.coordinate) : .missingAPIKey
    }

    private static func addressLines(of address: Address?) -> [String] {
        guard let address else { return [] }

        let lines = [
            [address.street, address.suite].compactMap { $0 }.joined(separator: streetSeparator),
            [address.city, address.zipcode].compactMap { $0 }.joined(separator: citySeparator)
        ]

        return lines.filter { !$0.isEmpty }
    }
}
