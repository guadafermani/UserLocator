import SwiftUI

@main
struct UserLocatorApp: App {
    private let dependencies = AppDependencies()

    @State private var path = NavigationPath()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                UserListView(
                    viewModel: dependencies.makeUserListViewModel(),
                    onSelect: { path.append($0) }
                )
                .navigationDestination(for: UsersRoute.self, destination: destination)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: UsersRoute) -> some View {
        switch route {
        case let .map(name, coordinate):
            UserMapView(viewModel: dependencies.makeUserMapViewModel(name: name, coordinate: coordinate))
        }
    }
}
