import Foundation
@testable import UserLocator

actor HTTPClientSpy: HTTPClient {
    private(set) var requestedEndpoints: [Endpoint] = []
    private let result: Result<Data, Error>

    init(result: Result<Data, Error>) {
        self.result = result
    }

    func data(for endpoint: Endpoint) async throws -> Data {
        requestedEndpoints.append(endpoint)
        return try result.get()
    }
}
