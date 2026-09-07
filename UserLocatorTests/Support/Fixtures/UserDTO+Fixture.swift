@testable import UserLocator

extension UserDTO {
    static func fixture(
        id: Int = 1,
        name: String = "Leanne Graham",
        username: String = "Bret",
        address: Address? = .fixture()
    ) -> UserDTO {
        UserDTO(id: id, name: name, username: username, address: address)
    }
}

extension UserDTO.Address {
    static func fixture(
        street: String? = "Kulas Light",
        suite: String? = "Apt. 556",
        city: String? = "Gwenborough",
        zipcode: String? = "92998-3874",
        geo: UserDTO.Geo? = .fixture()
    ) -> UserDTO.Address {
        UserDTO.Address(street: street, suite: suite, city: city, zipcode: zipcode, geo: geo)
    }
}

extension UserDTO.Geo {
    static func fixture(lat: String? = "-37.3159", lng: String? = "81.1496") -> UserDTO.Geo {
        UserDTO.Geo(lat: lat, lng: lng)
    }
}
