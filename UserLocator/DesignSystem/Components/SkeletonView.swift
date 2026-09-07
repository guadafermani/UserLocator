import SwiftUI

struct SkeletonView: View {
    let width: CGFloat?
    let height: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: AppRadius.small)
            .fill(AppColor.surfaceSecondary)
            .frame(width: width, height: height)
    }
}
