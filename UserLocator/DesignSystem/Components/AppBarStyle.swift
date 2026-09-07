import SwiftUI

extension View {
    func appBarStyle() -> some View {
        navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppColor.surface, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}
