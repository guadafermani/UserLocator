import Foundation

protocol HTTPClient: Sendable {
    func data(for endpoint: Endpoint) async throws -> Data
}
