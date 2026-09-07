import Foundation
@testable import UserLocator

actor FetchUsersUseCaseStub: FetchUsersUseCase {
    private(set) var executeCallCount = 0
    private let result: Result<[User], Error>
    private let delay: Duration

    init(result: Result<[User], Error>, delay: Duration = .zero) {
        self.result = result
        self.delay = delay
    }

    func execute() async throws -> [User] {
        executeCallCount += 1
        try? await Task.sleep(for: delay)
        return try result.get()
    }
}
