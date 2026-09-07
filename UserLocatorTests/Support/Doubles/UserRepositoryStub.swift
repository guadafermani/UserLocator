@testable import UserLocator

actor UserRepositoryStub: UserRepository {
    private let result: Result<[User], Error>

    init(result: Result<[User], Error>) {
        self.result = result
    }

    func fetchUsers() async throws -> [User] {
        try result.get()
    }
}
