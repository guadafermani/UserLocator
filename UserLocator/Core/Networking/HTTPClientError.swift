enum HTTPClientError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case unexpectedStatusCode(Int)
}
