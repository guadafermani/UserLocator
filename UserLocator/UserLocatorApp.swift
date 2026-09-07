import SwiftUI

@main
struct UserLocatorApp: App {
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            UserListView(viewModel: dependencies.makeUserListViewModel())
        }
    }
}
