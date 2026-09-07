import SwiftUI

struct UserListView: View {
    private static let emptyIcon = "person.2.slash"

    @State private var viewModel: UserListViewModel
    private let onSelect: (UsersRoute) -> Void

    init(viewModel: UserListViewModel, onSelect: @escaping (UsersRoute) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onSelect = onSelect
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .navigationTitle(Text("user_list.title"))
            .appBarStyle()
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
                action: StateView.Action(title: "user_list.empty.action", perform: reload)
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
                row(for: item)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(AppColor.surface)
                    .listRowSeparatorTint(AppColor.surfaceSecondary)
                    .alignmentGuide(.listRowSeparatorLeading) { _ in AppSpacing.large }
            }
            .listStyle(.plain)
            .refreshable { await viewModel.refresh() }
        }
        .animation(.easeInOut(duration: AppDuration.noticeTransition), value: refreshFailure)
    }

    @ViewBuilder
    private func row(for item: UserListItem) -> some View {
        if let route = item.route {
            Button { onSelect(route) } label: {
                UserRowView(item: item, showsDisclosure: true)
            }
            .buttonStyle(PressableRowStyle())
            .accessibilityHint(Text("user_list.row.accessibility_hint"))
        } else {
            UserRowView(item: item, showsDisclosure: false)
        }
    }

    private func failure(_ presentation: UsersErrorPresentation) -> some View {
        StateView(
            icon: presentation.icon,
            iconColor: AppColor.error,
            title: LocalizedStringKey(presentation.titleKey),
            message: LocalizedStringKey(presentation.messageKey),
            action: StateView.Action(title: "user_list.error.retry", perform: reload)
        )
    }

    private func reload() {
        Task { await viewModel.load() }
    }
}
