import Foundation

struct RemoteUserRepository: UserRepository {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func fetchUsers() async throws -> [User] {
        do {
            let data = try await client.data(for: .users)
            let dtos = try JSONDecoder().decode([UserDTO].self, from: data)
            return UserMapper.map(dtos)
        } catch {
            throw translated(error)
        }
    }

    private func translated(_ error: Error) -> Error {
        switch error {
        case let urlError as URLError:
            return urlError.code == .cancelled ? CancellationError() : UsersError.network
        case let httpError as HTTPClientError:
            return domainError(for: httpError)
        case is DecodingError:
            return UsersError.decoding
        case is CancellationError:
            return error
        default:
            return UsersError.unknown
        }
    }

    private func domainError(for httpError: HTTPClientError) -> UsersError {
        switch httpError {
        case .unexpectedStatusCode:
            return .server
        case .invalidURL, .invalidResponse:
            return .unknown
        }
    }
}
