import Foundation

struct URLSessionHTTPClient: HTTPClient {
    private static let successStatusCodes = 200..<300

    private let baseURL: String
    private let session: URLSession

    init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func data(for endpoint: Endpoint) async throws -> Data {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw HTTPClientError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }
        guard Self.successStatusCodes.contains(httpResponse.statusCode) else {
            throw HTTPClientError.unexpectedStatusCode(httpResponse.statusCode)
        }
        return data
    }
}
