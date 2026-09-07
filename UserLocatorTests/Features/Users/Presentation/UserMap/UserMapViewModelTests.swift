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
    func whenCreated_titleIsTheUserName() {
        let sut = makeSUT(name: "Leanne Graham")

        #expect(sut.title == "Leanne Graham")
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

    private func makeSUT(
        name: String = "Leanne Graham",
        coordinate: Coordinate = Coordinate(latitude: -37.3159, longitude: 81.1496),
        isMapAvailable: Bool = true
    ) -> UserMapViewModel {
        UserMapViewModel(name: name, coordinate: coordinate, isMapAvailable: isMapAvailable)
    }
}
