import SwiftUI

struct UserCardView: View {
    let card: UserCard

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            Text(card.name)
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColor.textPrimary)

            Text(card.username)
                .font(AppTypography.cardSubtitle)
                .foregroundStyle(AppColor.textSecondary)

            if !card.addressLines.isEmpty {
                addressLines
                    .padding(.top, AppSpacing.small)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppSpacing.large)
        .padding(.vertical, AppSpacing.extraLarge)
        .accessibilityElement(children: .combine)
    }

    private var addressLines: some View {
        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            ForEach(card.addressLines.indices, id: \.self) { index in
                Text(card.addressLines[index])
                    .font(AppTypography.cardDetail)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
    }
}
