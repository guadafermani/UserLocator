protocol FetchUsersUseCase: Sendable {
    func execute() async throws -> [User]
}
