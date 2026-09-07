import SwiftUI

struct RecenterButton: View {
    private static let icon = "dot.viewfinder"

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: Self.icon)
                .font(AppTypography.mapControlIcon)
                .foregroundStyle(AppColor.accent)
                .frame(width: AppSpacing.minimumTapTarget, height: AppSpacing.minimumTapTarget)
                .background(AppColor.surface, in: .circle)
                .shadow(
                    color: AppColor.shadow.color,
                    radius: AppElevation.controlBlur,
                    y: AppElevation.controlOffsetY
                )
        }
        .accessibilityLabel(Text("user_map.recenter.accessibility_label"))
    }
}
