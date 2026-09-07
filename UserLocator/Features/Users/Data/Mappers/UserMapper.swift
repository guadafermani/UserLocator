enum UserMapper {
    static func map(_ dto: UserDTO) -> User {
        User(
            id: dto.id,
            name: dto.name,
            username: dto.username,
            coordinate: coordinate(from: dto.address?.geo)
        )
    }

    static func map(_ dtos: [UserDTO]) -> [User] {
        dtos.map(map)
    }

    private static func coordinate(from geo: UserDTO.Geo?) -> Coordinate? {
        guard let geo,
              let latitude = geo.lat.flatMap(Double.init),
              let longitude = geo.lng.flatMap(Double.init)
        else { return nil }

        return Coordinate(latitude: latitude, longitude: longitude)
    }
}
