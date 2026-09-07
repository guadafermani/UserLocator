import Foundation

struct RemoteUserRepository: UserRepository {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func fetchUsers() async throws -> [User] {
        let data = try await client.data(for: .users)
        let dtos = try JSONDecoder().decode([UserDTO].self, from: data)
        return UserMapper.map(dtos)
    }
}
