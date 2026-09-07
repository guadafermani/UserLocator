struct UserListItem: Equatable, Identifiable, Sendable {
    let id: Int
    let title: String
    let subtitle: String
    let initials: String?
    let route: UsersRoute?
}
