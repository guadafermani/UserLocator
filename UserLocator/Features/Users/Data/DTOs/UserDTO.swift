struct UserDTO: Decodable, Equatable {
    let id: Int
    let name: String
    let username: String
    let address: Address?

    struct Address: Decodable, Equatable {
        let street: String?
        let suite: String?
        let city: String?
        let zipcode: String?
        let geo: Geo?
    }

    struct Geo: Decodable, Equatable {
        let lat: String?
        let lng: String?
    }
}
