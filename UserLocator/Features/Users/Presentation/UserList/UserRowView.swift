import SwiftUI

struct UserRowView: View {
    let item: UserListItem

    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            if let initials = item.initials {
                AvatarView(initials: initials)
            }

            VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                Text(item.title)
                    .font(AppTypography.rowTitle)
                    .foregroundStyle(AppColor.textPrimary)

                Text(item.subtitle)
                    .font(AppTypography.rowSubtitle)
                    .foregroundStyle(AppColor.textSecondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, AppSpacing.small)
        .accessibilityElement(children: .combine)
    }
}
