enum UserMapper {
    static func map(_ dto: UserDTO) -> User {
        User(id: dto.id, name: dto.name, username: dto.username)
    }

    static func map(_ dtos: [UserDTO]) -> [User] {
        dtos.map(map)
    }
}
