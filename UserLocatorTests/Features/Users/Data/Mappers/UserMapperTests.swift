import Testing
@testable import UserLocator

@Suite("UserMapper")
struct UserMapperTests {

    @Test
    func whenMappingDTO_producesEntityWithSameValues() {
        let dto = UserDTO.fixture(id: 7, name: "Kurtis Weissnat", username: "Elwyn.Skiles", address: nil)

        let user = UserMapper.map(dto)

        #expect(user == User(id: 7, name: "Kurtis Weissnat", username: "Elwyn.Skiles", coordinate: nil))
    }

    @Test
    func whenGeoHasNumericStrings_producesCoordinate() {
        let dto = UserDTO.fixture(address: .fixture(geo: .fixture(lat: "-37.3159", lng: "81.1496")))

        let user = UserMapper.map(dto)

        #expect(user.coordinate == Coordinate(latitude: -37.3159, longitude: 81.1496))
    }

    @Test(arguments: [
        UserDTO.fixture(address: nil),
        UserDTO.fixture(address: .fixture(geo: nil)),
        UserDTO.fixture(address: .fixture(geo: .fixture(lat: nil))),
        UserDTO.fixture(address: .fixture(geo: .fixture(lng: nil))),
        UserDTO.fixture(address: .fixture(geo: .fixture(lat: "abc"))),
        UserDTO.fixture(address: .fixture(geo: .fixture(lng: "")))
    ])
    func whenGeoCannotBeReadAsTwoNumbers_producesNoCoordinate(dto: UserDTO) {
        let user = UserMapper.map(dto)

        #expect(user.coordinate == nil)
    }

    @Test
    func whenMappingEmptyList_returnsEmptyList() {
        #expect(UserMapper.map([]).isEmpty)
    }
}
