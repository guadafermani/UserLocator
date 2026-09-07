@MainActor
struct AppDependencies {
    private let httpClient: HTTPClient = URLSessionHTTPClient(baseURL: API.baseURL)

    func makeUserListViewModel() -> UserListViewModel {
        UserListViewModel(
            fetchUsers: DefaultFetchUsersUseCase(
                repository: RemoteUserRepository(client: httpClient)
            )
        )
    }
}
