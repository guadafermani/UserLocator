@testable import UserLocator

extension User {
    static func fixture(
        id: Int = 1,
        name: String = "Leanne Graham",
        username: String = "Bret",
        coordinate: Coordinate? = Coordinate(latitude: -37.3159, longitude: 81.1496)
    ) -> User {
        User(id: id, name: name, username: username, coordinate: coordinate)
    }
}
