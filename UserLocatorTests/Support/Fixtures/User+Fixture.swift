@testable import UserLocator

extension User {
    static func fixture(
        id: Int = 1,
        name: String = "Leanne Graham",
        username: String = "Bret"
    ) -> User {
        User(id: id, name: name, username: username)
    }
}
