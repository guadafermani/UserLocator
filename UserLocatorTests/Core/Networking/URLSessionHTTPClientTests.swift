import Foundation
import Testing
@testable import UserLocator

@Suite("URLSessionHTTPClient", .serialized)
struct URLSessionHTTPClientTests {

    @Test
    func whenResponseIsSuccessful_returnsBody() async throws {
        let body = Data("[]".utf8)
        URLProtocolStub.stub(data: body, statusCode: 200)
        defer { URLProtocolStub.reset() }

        let receivedBody = try await makeSUT().data(for: .users)

        #expect(receivedBody == body)
    }

    @Test(arguments: [400, 401, 404, 500])
    func whenResponseIsNotSuccessful_throwsUnexpectedStatusCode(statusCode: Int) async {
        URLProtocolStub.stub(data: Data(), statusCode: statusCode)
        defer { URLProtocolStub.reset() }

        await #expect(throws: HTTPClientError.unexpectedStatusCode(statusCode)) {
            try await makeSUT().data(for: .users)
        }
    }

    @Test
    func whenSessionFails_propagatesTheError() async {
        URLProtocolStub.stub(error: .any)
        defer { URLProtocolStub.reset() }

        await #expect(throws: (any Error).self) {
            try await makeSUT().data(for: .users)
        }
    }

    @Test
    func whenResponseIsNotHTTP_throwsInvalidResponse() async {
        URLProtocolStub.stub(data: Data(), respondsAsHTTP: false)
        defer { URLProtocolStub.reset() }

        await #expect(throws: HTTPClientError.invalidResponse) {
            try await makeSUT().data(for: .users)
        }
    }

    @Test
    func whenBaseURLIsInvalid_throwsInvalidURL() async {
        await #expect(throws: HTTPClientError.invalidURL) {
            try await makeSUT(baseURL: "ht tp://x").data(for: .users)
        }
    }

    @Test
    func whenRequestingAnEndpoint_buildsURLWithItsPath() async throws {
        URLProtocolStub.stub(data: Data(), statusCode: 200)
        defer { URLProtocolStub.reset() }

        _ = try await makeSUT(baseURL: "https://example.com").data(for: Endpoint(path: "/users"))

        #expect(URLProtocolStub.lastRequestedURL == URL(string: "https://example.com/users"))
    }

    private func makeSUT(baseURL: String = "https://example.com") -> URLSessionHTTPClient {
        URLSessionHTTPClient(baseURL: baseURL, session: URLProtocolStub.makeSession())
    }
}
