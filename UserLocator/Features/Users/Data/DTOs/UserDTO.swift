struct UserDTO: Decodable, Equatable {
    let id: Int
    let name: String
    let username: String
    let address: Address?

    struct Address: Decodable, Equatable {
        let geo: Geo?
    }

    struct Geo: Decodable, Equatable {
        let lat: String?
        let lng: String?
    }
}
