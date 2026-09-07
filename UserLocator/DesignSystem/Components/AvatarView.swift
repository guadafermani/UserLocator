import SwiftUI

struct AvatarView: View {
    @ScaledMetric(relativeTo: .subheadline) private var size: CGFloat = 40

    let initials: String

    var body: some View {
        Text(initials)
            .font(AppTypography.avatarInitials)
            .foregroundStyle(AppColor.accent)
            .frame(width: size, height: size)
            .background(AppColor.surfaceSecondary, in: .circle)
            .accessibilityHidden(true)
    }
}
