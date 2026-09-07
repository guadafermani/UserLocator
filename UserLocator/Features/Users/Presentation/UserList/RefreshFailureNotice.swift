import SwiftUI

struct RefreshFailureNotice: View {
    private static let icon = "exclamationmark.triangle.fill"
    private static let backgroundOpacity = 0.12

    let textKey: String

    private var text: String {
        String(localized: String.LocalizationValue(textKey))
    }

    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: Self.icon)

            Text(text)

            Spacer(minLength: 0)
        }
        .font(AppTypography.notice)
        .foregroundStyle(AppColor.error)
        .padding(.horizontal, AppSpacing.large)
        .padding(.vertical, AppSpacing.small)
        .frame(maxWidth: .infinity)
        .background(AppColor.error.opacity(Self.backgroundOpacity))
        .accessibilityElement(children: .combine)
        .onAppear { AccessibilityNotification.Announcement(text).post() }
    }
}
