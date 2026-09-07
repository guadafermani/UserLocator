import Foundation

@MainActor
struct AppDependencies {
    private let httpClient: HTTPClient = URLSessionHTTPClient(baseURL: API.baseURL)
    private let isMapAvailable: Bool

    init() {
        let configuration = AppConfiguration(
            googleMapsAPIKey: Bundle.main.object(
                forInfoDictionaryKey: AppConfiguration.googleMapsAPIKeyInfoKey
            ) as? String
        )
        isMapAvailable = GoogleMapsActivator().activate(apiKey: configuration.googleMapsAPIKey)
    }

    func makeUserListViewModel() -> UserListViewModel {
        UserListViewModel(
            fetchUsers: DefaultFetchUsersUseCase(
                repository: RemoteUserRepository(client: httpClient)
            )
        )
    }

    func makeUserMapViewModel(name: String, coordinate: Coordinate) -> UserMapViewModel {
        UserMapViewModel(name: name, coordinate: coordinate, isMapAvailable: isMapAvailable)
    }
}
