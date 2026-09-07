import Foundation
import os

final class URLProtocolStub: URLProtocol {

    private struct Stub: Sendable {
        let data: Data?
        let statusCode: Int?
        let error: TestError?
        let respondsAsHTTP: Bool
    }

    private static let currentStub = OSAllocatedUnfairLock<Stub?>(initialState: nil)
    private static let requestedURLs = OSAllocatedUnfairLock<[URL]>(initialState: [])

    static var lastRequestedURL: URL? {
        requestedURLs.withLock { $0.last }
    }

    static func stub(
        data: Data? = nil,
        statusCode: Int? = nil,
        error: TestError? = nil,
        respondsAsHTTP: Bool = true
    ) {
        currentStub.withLock {
            $0 = Stub(data: data, statusCode: statusCode, error: error, respondsAsHTTP: respondsAsHTTP)
        }
    }

    static func reset() {
        currentStub.withLock { $0 = nil }
        requestedURLs.withLock { $0 = [] }
    }

    static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: configuration)
    }

    override static func canInit(with request: URLRequest) -> Bool {
        true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let url = request.url {
            Self.requestedURLs.withLock { $0.append(url) }
        }

        let stub = Self.currentStub.withLock { $0 }

        if let error = stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let response = makeResponse(for: stub) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let data = stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    private func makeResponse(for stub: Stub?) -> URLResponse? {
        guard let url = request.url else { return nil }
        guard stub?.respondsAsHTTP == true else {
            return URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        }
        return HTTPURLResponse(
            url: url,
            statusCode: stub?.statusCode ?? 200,
            httpVersion: nil,
            headerFields: nil
        )
    }
}
