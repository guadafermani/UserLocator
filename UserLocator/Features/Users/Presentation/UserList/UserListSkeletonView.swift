import SwiftUI

struct UserListSkeletonView: View {
    private static let rowCount = 8
    private static let titleWidth: CGFloat = 88
    private static let titleHeight: CGFloat = 15
    private static let subtitleWidth: CGFloat = 152
    private static let subtitleHeight: CGFloat = 13

    @ScaledMetric(relativeTo: .subheadline) private var avatarSize: CGFloat = 40

    var body: some View {
        List(0..<Self.rowCount, id: \.self) { _ in
            row
                .listRowBackground(AppColor.surface.color)
                .listRowSeparatorTint(AppColor.surfaceSecondary.color)
        }
        .listStyle(.plain)
        .scrollDisabled(true)
        .shimmering()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("user_list.loading.accessibility"))
    }

    private var row: some View {
        HStack(spacing: AppSpacing.medium) {
            Circle()
                .fill(AppColor.surfaceSecondary)
                .frame(width: avatarSize, height: avatarSize)

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                SkeletonView(width: Self.titleWidth, height: Self.titleHeight)
                SkeletonView(width: Self.subtitleWidth, height: Self.subtitleHeight)
            }
        }
        .padding(.vertical, AppSpacing.small)
    }
}
