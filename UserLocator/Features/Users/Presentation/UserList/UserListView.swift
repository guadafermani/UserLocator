import SwiftUI

struct UserListView: View {
    @State private var viewModel: UserListViewModel

    init(viewModel: UserListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColor.background)
                .navigationTitle(Text("user_list.title"))
                .appBarStyle()
        }
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            UserListSkeletonView()

        case let .loaded(items):
            List(items) { item in
                UserRowView(item: item)
                    .listRowBackground(AppColor.surface)
                    .listRowSeparatorTint(AppColor.surfaceSecondary)
            }
            .listStyle(.plain)

        case .failed:
            Text("user_list.error.message")
                .font(AppTypography.message)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(AppSpacing.extraLarge)
        }
    }
}
