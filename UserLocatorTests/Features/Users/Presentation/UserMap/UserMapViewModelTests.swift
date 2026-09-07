import Testing
@testable import UserLocator

@MainActor
@Suite("UserMapViewModel")
struct UserMapViewModelTests {

    @Test
    func whenTheMapIsAvailable_isReadyOnTheReceivedCoordinate() {
        let coordinate = Coordinate(latitude: -37.3159, longitude: 81.1496)

        let sut = makeSUT(coordinate: coordinate, isMapAvailable: true)

        #expect(sut.state == .ready(coordinate))
    }

    @Test
    func whenTheMapIsNotAvailable_reportsTheMissingAPIKey() {
        let sut = makeSUT(isMapAvailable: false)

        #expect(sut.state == .missingAPIKey)
    }

    @Test
    func whenCreated_markerInitialsComeFromTheName() {
        let sut = makeSUT(name: "Leanne Graham")

        #expect(sut.markerInitials == "LG")
    }

    @Test
    func whenTheNameHasNoInitials_hasNoMarkerInitials() {
        let sut = makeSUT(name: "   ")

        #expect(sut.markerInitials == nil)
    }

    @Test
    func whenTheUserHasNoAddress_showsOnlyTheNameAndTheUsername() {
        let sut = makeSUT(name: "Leanne Graham", username: "Bret", address: nil)

        #expect(sut.card == UserCard(name: "Leanne Graham", username: "Bret", addressLines: []))
    }

    @Test
    func whenTheAddressIsComplete_showsTheStreetAndTheCityLines() {
        let sut = makeSUT(address: .fixture())

        #expect(sut.card.addressLines == ["Kulas Light, Apt. 556", "Gwenborough 92998-3874"])
    }

    @Test(arguments: [
        (Address.fixture(suite: nil), "Kulas Light"),
        (Address.fixture(street: nil), "Apt. 556")
    ])
    func whenAFieldOfTheStreetLineIsAbsent_joinsWhatIsLeft(address: Address, expected: String) {
        let sut = makeSUT(address: address)

        #expect(sut.card.addressLines.first == expected)
    }

    @Test(arguments: [
        (Address.fixture(zipcode: nil), "Gwenborough"),
        (Address.fixture(city: nil), "92998-3874")
    ])
    func whenAFieldOfTheCityLineIsAbsent_joinsWhatIsLeft(address: Address, expected: String) {
        let sut = makeSUT(address: address)

        #expect(sut.card.addressLines.last == expected)
    }

    @Test(arguments: [
        (Address.fixture(street: nil, suite: nil), ["Gwenborough 92998-3874"]),
        (Address.fixture(city: nil, zipcode: nil), ["Kulas Light, Apt. 556"])
    ])
    func whenALineHasNoFields_dropsThatLine(address: Address, expected: [String]) {
        let sut = makeSUT(address: address)

        #expect(sut.card.addressLines == expected)
    }

    private func makeSUT(
        name: String = "Leanne Graham",
        username: String = "Bret",
        address: Address? = .fixture(),
        coordinate: Coordinate = Coordinate(latitude: -37.3159, longitude: 81.1496),
        isMapAvailable: Bool = true
    ) -> UserMapViewModel {
        UserMapViewModel(
            user: LocatedUser(
                name: name,
                username: username,
                address: address,
                coordinate: coordinate
            ),
            isMapAvailable: isMapAvailable
        )
    }
}
