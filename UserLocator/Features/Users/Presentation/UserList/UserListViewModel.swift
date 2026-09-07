import Observation

@MainActor
@Observable
final class UserListViewModel {
    private(set) var state: UserListState = .loading

    private let fetchUsers: FetchUsersUseCase
    private var runningLoad: Task<Void, Never>?

    init(fetchUsers: FetchUsersUseCase) {
        self.fetchUsers = fetchUsers
    }

    func load() async {
        if let runningLoad {
            return await runningLoad.value
        }

        state = .loading
        let load = Task { await fetch(failingWith: UserListState.failed) }
        runningLoad = load
        await load.value
        runningLoad = nil
    }

    func refresh() async {
        guard case let .loaded(items, _) = state else { return }

        state = .loaded(items, refreshFailure: nil)
        await fetch(failingWith: { .loaded(items, refreshFailure: $0) })
    }

    private func fetch(failingWith failureState: (UsersError) -> UserListState) async {
        do {
            state = makeState(for: try await fetchUsers.execute())
        } catch is CancellationError {
            return
        } catch {
            state = failureState(makeFailure(from: error))
        }
    }

    private func makeState(for users: [User]) -> UserListState {
        let items = users.map(makeItem)
        return items.isEmpty ? .empty : .loaded(items, refreshFailure: nil)
    }

    private func makeFailure(from error: Error) -> UsersError {
        error as? UsersError ?? .unknown
    }

    private func makeItem(from user: User) -> UserListItem {
        UserListItem(
            id: user.id,
            title: user.username,
            subtitle: user.name,
            initials: InitialsFormatter.initials(from: user.name),
            route: user.coordinate.map { .map(name: user.name, coordinate: $0) }
        )
    }
}
