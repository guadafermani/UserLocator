import Foundation
import Testing
@testable import UserLocator

@Suite("RemoteUserRepository")
struct RemoteUserRepositoryTests {

    @Test
    func whenJSONIsValid_deliversUsers() async throws {
        let sut = RemoteUserRepository(client: HTTPClientSpy(result: .success(UsersJSONFixture.valid)))

        let users = try await sut.fetchUsers()

        #expect(users == [
            User(
                id: 1,
                name: "Leanne Graham",
                username: "Bret",
                address: Address(
                    street: "Kulas Light",
                    suite: "Apt. 556",
                    city: "Gwenborough",
                    zipcode: "92998-3874"
                ),
                coordinate: Coordinate(latitude: -37.3159, longitude: 81.1496)
            ),
            User(
                id: 6,
                name: "Mrs. Dennis Schulist",
                username: "Leopoldo_Corkery",
                address: Address(
                    street: "Norberto Crossing",
                    suite: "Apt. 950",
                    city: "South Christy",
                    zipcode: "23505-1337"
                ),
                coordinate: Coordinate(latitude: -71.4197, longitude: 71.7478)
            ),
            User(
                id: 8,
                name: "Nicholas Runolfsdottir V",
                username: "Maxime_Nienow",
                address: Address(
                    street: "Ellsworth Summit",
                    suite: "Suite 729",
                    city: "Aliyaview",
                    zipcode: "45169"
                ),
                coordinate: Coordinate(latitude: -14.3990, longitude: -120.7677)
            )
        ])
    }

    @Test
    func whenFetching_requestsTheUsersEndpoint() async throws {
        let client = HTTPClientSpy(result: .success(UsersJSONFixture.valid))

        _ = try await RemoteUserRepository(client: client).fetchUsers()

        #expect(await client.requestedEndpoints == [.users])
    }

    @Test(arguments: [URLError.Code.notConnectedToInternet, .timedOut, .networkConnectionLost])
    func whenTheClientFailsWithATransportError_throwsNetwork(code: URLError.Code) async {
        let sut = RemoteUserRepository(client: HTTPClientSpy(result: .failure(URLError(code))))

        await #expect(throws: UsersError.network) {
            try await sut.fetchUsers()
        }
    }

    @Test
    func whenTheResponseHasAnErrorStatusCode_throwsServer() async {
        let client = HTTPClientSpy(result: .failure(HTTPClientError.unexpectedStatusCode(500)))
        let sut = RemoteUserRepository(client: client)

        await #expect(throws: UsersError.server) {
            try await sut.fetchUsers()
        }
    }

    @Test
    func whenJSONIsMalformed_throwsDecoding() async {
        let sut = RemoteUserRepository(client: HTTPClientSpy(result: .success(UsersJSONFixture.malformed)))

        await #expect(throws: UsersError.decoding) {
            try await sut.fetchUsers()
        }
    }

    @Test(arguments: [HTTPClientError.invalidURL, .invalidResponse])
    func whenTheClientCannotProduceAUsableResponse_throwsUnknown(error: HTTPClientError) async {
        let sut = RemoteUserRepository(client: HTTPClientSpy(result: .failure(error)))

        await #expect(throws: UsersError.unknown) {
            try await sut.fetchUsers()
        }
    }

    @Test
    func whenTheClientFailsWithAnUnrecognisedError_throwsUnknown() async {
        let sut = RemoteUserRepository(client: HTTPClientSpy(result: .failure(TestError.any)))

        await #expect(throws: UsersError.unknown) {
            try await sut.fetchUsers()
        }
    }

    @Test
    func whenTheRequestIsCancelled_throwsCancellationError() async {
        let client = HTTPClientSpy(result: .failure(URLError(.cancelled)))
        let sut = RemoteUserRepository(client: client)

        await #expect(throws: CancellationError.self) {
            try await sut.fetchUsers()
        }
    }
}
