import SwiftUI

struct PressableRowStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .background(configuration.isPressed ? AppColor.surfaceSecondary : AppColor.surface)
    }
}
