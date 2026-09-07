import Testing
@testable import UserLocator

@MainActor
@Suite("UserListViewModel")
struct UserListViewModelTests {

    @Test
    func whenCreated_isLoading() {
        let sut = makeSUT(result: .success([]))

        #expect(sut.state == .loading)
    }

    @Test
    func whenLoadSucceeds_showsOneItemPerUser() async {
        let sut = makeSUT(result: .success([.fixture(id: 1), .fixture(id: 2)]))

        await sut.load()

        #expect(sut.state == .loaded([
            UserListItem(id: 1, title: "Bret", subtitle: "Leanne Graham", initials: "LG"),
            UserListItem(id: 2, title: "Bret", subtitle: "Leanne Graham", initials: "LG")
        ]))
    }

    @Test
    func whenLoadSucceeds_preservesTheAPIOrder() async {
        let sut = makeSUT(result: .success([.fixture(id: 3), .fixture(id: 1), .fixture(id: 2)]))

        await sut.load()

        #expect(sut.state.items.map(\.id) == [3, 1, 2])
    }

    @Test
    func whenLoadSucceeds_mapsEachUsersInitials() async {
        let sut = makeSUT(result: .success([.fixture(name: "Mrs. Dennis Schulist")]))

        await sut.load()

        #expect(sut.state.items.map(\.initials) == ["DS"])
    }

    @Test
    func whenLoadFails_showsTheFailedState() async {
        let sut = makeSUT(result: .failure(TestError.any))

        await sut.load()

        #expect(sut.state == .failed)
    }

    @Test
    func whenLoadIsCalledTwiceConcurrently_requestsUsersOnce() async {
        let useCase = FetchUsersUseCaseStub(result: .success([]), delay: .milliseconds(50))
        let sut = UserListViewModel(fetchUsers: useCase)

        async let firstLoad: Void = sut.load()
        async let secondLoad: Void = sut.load()
        _ = await (firstLoad, secondLoad)

        #expect(await useCase.executeCallCount == 1)
    }

    private func makeSUT(result: Result<[User], Error>) -> UserListViewModel {
        UserListViewModel(fetchUsers: FetchUsersUseCaseStub(result: result))
    }
}

private extension UserListState {
    var items: [UserListItem] {
        guard case let .loaded(items) = self else { return [] }
        return items
    }
}
