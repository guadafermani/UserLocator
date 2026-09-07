import Foundation

enum UserMapper {
    static func map(_ dto: UserDTO) -> User {
        User(
            id: dto.id,
            name: dto.name,
            username: dto.username,
            address: address(from: dto.address),
            coordinate: coordinate(from: dto.address?.geo)
        )
    }

    static func map(_ dtos: [UserDTO]) -> [User] {
        dtos.map(map)
    }

    private static func address(from dto: UserDTO.Address?) -> Address? {
        let street = normalised(dto?.street)
        let suite = normalised(dto?.suite)
        let city = normalised(dto?.city)
        let zipcode = normalised(dto?.zipcode)

        guard [street, suite, city, zipcode].contains(where: { $0 != nil }) else { return nil }

        return Address(street: street, suite: suite, city: city, zipcode: zipcode)
    }

    private static func normalised(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty
        else { return nil }

        return trimmed
    }

    private static func coordinate(from geo: UserDTO.Geo?) -> Coordinate? {
        guard let geo,
              let latitude = geo.lat.flatMap(Double.init),
              let longitude = geo.lng.flatMap(Double.init)
        else { return nil }

        return Coordinate(latitude: latitude, longitude: longitude)
    }
}
