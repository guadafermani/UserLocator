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
            User(id: 1, name: "Leanne Graham", username: "Bret"),
            User(id: 6, name: "Mrs. Dennis Schulist", username: "Leopoldo_Corkery"),
            User(id: 8, name: "Nicholas Runolfsdottir V", username: "Maxime_Nienow")
        ])
    }

    @Test
    func whenJSONIsMalformed_throwsError() async {
        let sut = RemoteUserRepository(client: HTTPClientSpy(result: .success(UsersJSONFixture.malformed)))

        await #expect(throws: (any Error).self) {
            try await sut.fetchUsers()
        }
    }

    @Test
    func whenClientFails_propagatesTheError() async {
        let sut = RemoteUserRepository(client: HTTPClientSpy(result: .failure(TestError.any)))

        await #expect(throws: TestError.any) {
            try await sut.fetchUsers()
        }
    }

    @Test
    func whenFetching_requestsTheUsersEndpoint() async throws {
        let client = HTTPClientSpy(result: .success(UsersJSONFixture.valid))

        _ = try await RemoteUserRepository(client: client).fetchUsers()

        #expect(await client.requestedEndpoints == [.users])
    }
}
