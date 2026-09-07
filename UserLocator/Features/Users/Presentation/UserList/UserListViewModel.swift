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

        let load = Task { await performLoad() }
        runningLoad = load
        await load.value
        runningLoad = nil
    }

    private func performLoad() async {
        do {
            state = .loaded(try await fetchUsers.execute().map(makeItem))
        } catch {
            state = .failed
        }
    }

    private func makeItem(from user: User) -> UserListItem {
        UserListItem(
            id: user.id,
            title: user.username,
            subtitle: user.name,
            initials: InitialsFormatter.initials(from: user.name)
        )
    }
}
