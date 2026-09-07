protocol UserRepository: Sendable {
    func fetchUsers() async throws -> [User]
}
