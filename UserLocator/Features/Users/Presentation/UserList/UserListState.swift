enum UserListState: Equatable {
    case loading
    case loaded([UserListItem], refreshFailure: UsersError?)
    case empty
    case failed(UsersError)
}
