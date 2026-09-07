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
        let coordinate = Coordinate(latitude: -37.3159, longitude: 81.1496)
        let sut = makeSUT(result: .success([.fixture(id: 1), .fixture(id: 2)]))

        await sut.load()

        #expect(sut.state == .loaded([
            UserListItem(
                id: 1,
                title: "Bret",
                subtitle: "Leanne Graham",
                initials: "LG",
                route: .map(name: "Leanne Graham", coordinate: coordinate)
            ),
            UserListItem(
                id: 2,
                title: "Bret",
                subtitle: "Leanne Graham",
                initials: "LG",
                route: .map(name: "Leanne Graham", coordinate: coordinate)
            )
        ], refreshFailure: nil))
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
    func whenLoadSucceedsWithNoUsers_showsTheEmptyState() async {
        let sut = makeSUT(result: .success([]))

        await sut.load()

        #expect(sut.state == .empty)
    }

    @Test(arguments: UsersError.allCases)
    func whenLoadFailsWithADomainError_showsThatFailure(error: UsersError) async {
        let sut = makeSUT(result: .failure(error))

        await sut.load()

        #expect(sut.state == .failed(error))
    }

    @Test
    func whenLoadFailsWithAnUnrecognisedError_showsUnknown() async {
        let sut = makeSUT(result: .failure(TestError.any))

        await sut.load()

        #expect(sut.state == .failed(.unknown))
    }

    @Test
    func whenLoadIsCancelled_keepsTheCurrentState() async {
        let sut = makeSUT(result: .failure(CancellationError()))

        await sut.load()

        #expect(sut.state == .loading)
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

    @Test
    func whenLoadingAgainAfterAFailure_returnsToTheLoadingState() async throws {
        let sut = makeSUT(results: [.failure(UsersError.network), .success([.fixture()])], delay: .milliseconds(50))
        await sut.load()

        let reload = Task { await sut.load() }
        try await Task.sleep(for: .milliseconds(20))

        #expect(sut.state == .loading)
        await reload.value
    }

    @Test
    func whenRetryingAfterAFailure_showsTheList() async {
        let sut = makeSUT(results: [.failure(UsersError.network), .success([.fixture(id: 1)])])

        await sut.load()
        await sut.load()

        #expect(sut.state.items.map(\.id) == [1])
    }

    @Test
    func whenRefreshSucceeds_replacesTheItems() async {
        let sut = makeSUT(results: [.success([.fixture(id: 1)]), .success([.fixture(id: 2)])])
        await sut.load()

        await sut.refresh()

        #expect(sut.state.items.map(\.id) == [2])
    }

    @Test
    func whenRefreshSucceedsWithNoUsers_showsTheEmptyState() async {
        let sut = makeSUT(results: [.success([.fixture()]), .success([])])
        await sut.load()

        await sut.refresh()

        #expect(sut.state == .empty)
    }

    @Test
    func whenRefreshFails_keepsTheItemsOnScreen() async {
        let sut = makeSUT(results: [.success([.fixture(id: 1)]), .failure(UsersError.network)])
        await sut.load()

        await sut.refresh()

        #expect(sut.state.items.map(\.id) == [1])
    }

    @Test
    func whenRefreshFails_showsTheFailureAsANotice() async {
        let sut = makeSUT(results: [.success([.fixture()]), .failure(UsersError.server)])
        await sut.load()

        await sut.refresh()

        #expect(sut.state.refreshFailure == .server)
    }

    @Test
    func whenRefreshStarts_clearsThePreviousNotice() async throws {
        let sut = makeSUT(
            results: [.success([.fixture()]), .failure(UsersError.network), .success([.fixture()])],
            delay: .milliseconds(50)
        )
        await sut.load()
        await sut.refresh()

        let secondRefresh = Task { await sut.refresh() }
        try await Task.sleep(for: .milliseconds(20))

        #expect(sut.state.refreshFailure == nil)
        await secondRefresh.value
    }

    @Test
    func whenRefreshIsCancelled_keepsTheStateUnchanged() async {
        let sut = makeSUT(results: [.success([.fixture()]), .failure(CancellationError())])
        await sut.load()
        let stateBeforeRefresh = sut.state

        await sut.refresh()

        #expect(sut.state == stateBeforeRefresh)
    }

    @Test
    func whenUserHasACoordinate_itemRoutesToTheMapWithNameAndCoordinate() async {
        let coordinate = Coordinate(latitude: -37.3159, longitude: 81.1496)
        let sut = makeSUT(result: .success([.fixture(name: "Leanne Graham", coordinate: coordinate)]))

        await sut.load()

        #expect(sut.state.items.first?.route == .map(name: "Leanne Graham", coordinate: coordinate))
    }

    @Test
    func whenUserHasNoCoordinate_itemHasNoRoute() async {
        let sut = makeSUT(result: .success([.fixture(coordinate: nil)]))

        await sut.load()

        #expect(sut.state.items.first?.route == nil)
    }

    @Test
    func whenRefreshingBeforeTheListIsLoaded_doesNotRequestUsers() async {
        let useCase = FetchUsersUseCaseStub(result: .success([]))
        let sut = UserListViewModel(fetchUsers: useCase)

        await sut.refresh()

        #expect(await useCase.executeCallCount == 0)
    }

    private func makeSUT(result: Result<[User], Error>) -> UserListViewModel {
        UserListViewModel(fetchUsers: FetchUsersUseCaseStub(result: result))
    }

    private func makeSUT(
        results: [Result<[User], Error>],
        delay: Duration = .zero
    ) -> UserListViewModel {
        UserListViewModel(fetchUsers: FetchUsersUseCaseStub(results: results, delay: delay))
    }
}

private extension UserListState {
    var items: [UserListItem] {
        guard case let .loaded(items, _) = self else { return [] }
        return items
    }

    var refreshFailure: UsersError? {
        guard case let .loaded(_, failure) = self else { return nil }
        return failure
    }
}
