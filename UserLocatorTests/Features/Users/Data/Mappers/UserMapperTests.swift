import Testing
@testable import UserLocator

@Suite("UserMapper")
struct UserMapperTests {

    @Test
    func whenMappingDTO_producesEntityWithSameValues() {
        let dto = UserDTO.fixture(id: 7, name: "Kurtis Weissnat", username: "Elwyn.Skiles", address: nil)

        let user = UserMapper.map(dto)

        #expect(user == User(
            id: 7,
            name: "Kurtis Weissnat",
            username: "Elwyn.Skiles",
            address: nil,
            coordinate: nil
        ))
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
    func whenTheAddressIsComplete_mapsEveryField() {
        let dto = UserDTO.fixture(address: .fixture(
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874"
        ))

        let user = UserMapper.map(dto)

        #expect(user.address == Address(
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874"
        ))
    }

    @Test
    func whenAnAddressFieldIsAbsent_leavesItAbsent() {
        let dto = UserDTO.fixture(address: .fixture(suite: nil))

        let user = UserMapper.map(dto)

        #expect(user.address?.suite == nil)
    }

    @Test(arguments: ["", "   ", "\n"])
    func whenAnAddressFieldIsBlank_leavesItAbsent(value: String) {
        let dto = UserDTO.fixture(address: .fixture(street: value))

        let user = UserMapper.map(dto)

        #expect(user.address?.street == nil)
    }

    @Test
    func whenAnAddressFieldHasSurroundingSpaces_trimsThem() {
        let dto = UserDTO.fixture(address: .fixture(city: "  Gwenborough  "))

        let user = UserMapper.map(dto)

        #expect(user.address?.city == "Gwenborough")
    }

    @Test
    func whenNoAddressFieldHasValue_producesNoAddress() {
        let dto = UserDTO.fixture(address: .fixture(street: "  ", suite: nil, city: "", zipcode: nil))

        let user = UserMapper.map(dto)

        #expect(user.address == nil)
    }

    @Test
    func whenMappingEmptyList_returnsEmptyList() {
        #expect(UserMapper.map([]).isEmpty)
    }
}
