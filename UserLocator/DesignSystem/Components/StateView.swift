import SwiftUI

struct StateView: View {
    struct Action {
        let title: LocalizedStringKey
        let perform: () -> Void
    }

    let icon: String
    let iconColor: AppColorToken
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    let action: Action?

    init(
        icon: String,
        iconColor: AppColorToken,
        title: LocalizedStringKey,
        message: LocalizedStringKey,
        action: Action? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.message = message
        self.action = action
    }

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

            if let action {
                Button(action: action.perform) {
                    Text(action.title)
                        .padding(.horizontal, AppSpacing.large)
                        .frame(minHeight: AppSpacing.minimumTapTarget)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColor.accent)
            }
        }
        .padding(AppSpacing.extraLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
