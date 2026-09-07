import Foundation
@testable import UserLocator

actor FetchUsersUseCaseStub: FetchUsersUseCase {
    private(set) var executeCallCount = 0
    private let results: [Result<[User], Error>]
    private let delay: Duration

    init(result: Result<[User], Error>, delay: Duration = .zero) {
        self.init(results: [result], delay: delay)
    }

    init(results: [Result<[User], Error>], delay: Duration = .zero) {
        self.results = results
        self.delay = delay
    }

    func execute() async throws -> [User] {
        let result = results[min(executeCallCount, results.count - 1)]
        executeCallCount += 1
        try? await Task.sleep(for: delay)
        return try result.get()
    }
}
