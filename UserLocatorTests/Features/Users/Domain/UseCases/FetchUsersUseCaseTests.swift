import Testing
@testable import UserLocator

@Suite("FetchUsersUseCase")
struct FetchUsersUseCaseTests {

    @Test
    func whenRepositorySucceeds_deliversUsers() async throws {
        let users = [User.fixture(id: 1), User.fixture(id: 2)]
        let sut = DefaultFetchUsersUseCase(repository: UserRepositoryStub(result: .success(users)))

        let deliveredUsers = try await sut.execute()

        #expect(deliveredUsers == users)
    }

    @Test
    func whenRepositoryFails_throwsError() async {
        let sut = DefaultFetchUsersUseCase(repository: UserRepositoryStub(result: .failure(TestError.any)))

        await #expect(throws: TestError.any) {
            try await sut.execute()
        }
    }
}
