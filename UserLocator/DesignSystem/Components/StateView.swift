import SwiftUI

struct StateView: View {
    let icon: String
    let iconColor: Color
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    let actionTitle: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: icon)
                .font(AppTypography.stateIcon)
                .foregroundStyle(iconColor)
                .accessibilityHidden(true)

            VStack(spacing: AppSpacing.small) {
                Text(title)
                    .font(AppTypography.stateTitle)
                    .foregroundStyle(AppColor.textPrimary)

                Text(message)
                    .font(AppTypography.message)
                    .foregroundStyle(AppColor.textSecondary)
            }
            .multilineTextAlignment(.center)

            Button(action: action) {
                Text(actionTitle)
                    .padding(.horizontal, AppSpacing.large)
                    .frame(minHeight: AppSpacing.minimumTapTarget)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppColor.accent)
        }
        .padding(AppSpacing.extraLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
