import Foundation

enum UsersJSONFixture {
    static let valid = Data("""
    [
      { "id": 1, "name": "Leanne Graham", "username": "Bret" },
      { "id": 6, "name": "Mrs. Dennis Schulist", "username": "Leopoldo_Corkery" },
      { "id": 8, "name": "Nicholas Runolfsdottir V", "username": "Maxime_Nienow" }
    ]
    """.utf8)

    static let malformed = Data("{ not json".utf8)
}
