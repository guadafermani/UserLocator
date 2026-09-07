import Foundation

enum UsersJSONFixture {
    static let valid = Data("""
    [
      {
        "id": 1, "name": "Leanne Graham", "username": "Bret",
        "address": { "geo": { "lat": "-37.3159", "lng": "81.1496" } }
      },
      {
        "id": 6, "name": "Mrs. Dennis Schulist", "username": "Leopoldo_Corkery",
        "address": { "geo": { "lat": "-71.4197", "lng": "71.7478" } }
      },
      {
        "id": 8, "name": "Nicholas Runolfsdottir V", "username": "Maxime_Nienow",
        "address": { "geo": { "lat": "-14.3990", "lng": "-120.7677" } }
      }
    ]
    """.utf8)

    static let malformed = Data("{ not json".utf8)
}
