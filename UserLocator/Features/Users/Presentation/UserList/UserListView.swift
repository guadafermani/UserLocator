import SwiftUI

struct UserListView: View {
    private static let emptyIcon = "person.2.slash"

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

        case let .loaded(items, refreshFailure):
            loadedList(items, refreshFailure: refreshFailure)

        case .empty:
            StateView(
                icon: Self.emptyIcon,
                iconColor: AppColor.textSecondary,
                title: "user_list.empty.title",
                message: "user_list.empty.message",
                actionTitle: "user_list.empty.action",
                action: reload
            )

        case let .failed(error):
            failure(UsersErrorPresentation(error))
        }
    }

    private func loadedList(_ items: [UserListItem], refreshFailure: UsersError?) -> some View {
        VStack(spacing: 0) {
            if let refreshFailure {
                RefreshFailureNotice(textKey: UsersErrorPresentation(refreshFailure).noticeKey)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            List(items) { item in
                UserRowView(item: item)
                    .listRowBackground(AppColor.surface)
                    .listRowSeparatorTint(AppColor.surfaceSecondary)
            }
            .listStyle(.plain)
            .refreshable { await viewModel.refresh() }
        }
        .animation(.easeInOut(duration: AppDuration.noticeTransition), value: refreshFailure)
    }

    private func failure(_ presentation: UsersErrorPresentation) -> some View {
        StateView(
            icon: presentation.icon,
            iconColor: AppColor.error,
            title: LocalizedStringKey(presentation.titleKey),
            message: LocalizedStringKey(presentation.messageKey),
            actionTitle: "user_list.error.retry",
            action: reload
        )
    }

    private func reload() {
        Task { await viewModel.load() }
    }
}
