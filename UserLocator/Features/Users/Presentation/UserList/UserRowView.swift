import SwiftUI

struct UserRowView: View {
    private static let disclosureIcon = "chevron.right"

    let item: UserListItem
    let showsDisclosure: Bool

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

            if showsDisclosure {
                Image(systemName: Self.disclosureIcon)
                    .font(AppTypography.disclosure)
                    .foregroundStyle(AppColor.textSecondary)
                    .accessibilityHidden(true)
            }
        }
        .padding(.horizontal, AppSpacing.large)
        .padding(.vertical, AppSpacing.extraLarge)
        .accessibilityElement(children: .combine)
    }
}
