enum UserListState: Equatable {
    case loading
    case loaded([UserListItem])
    case failed
}
