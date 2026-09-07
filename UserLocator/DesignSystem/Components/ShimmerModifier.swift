import SwiftUI

private struct ShimmerModifier: ViewModifier {
    private static let highlightWidthRatio: CGFloat = 0.5
    private static let highlightOpacity: Double = 0.65

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .overlay { highlight }
            .clipped()
            .onAppear(perform: startAnimating)
    }

    @ViewBuilder
    private var highlight: some View {
        if !reduceMotion {
            GeometryReader { proxy in
                let highlightWidth = proxy.size.width * Self.highlightWidthRatio

                LinearGradient(
                    colors: [
                        .clear,
                        AppColor.surface.opacity(Self.highlightOpacity),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: highlightWidth)
                .offset(x: isAnimating ? proxy.size.width : -highlightWidth)
            }
            .allowsHitTesting(false)
        }
    }

    private func startAnimating() {
        guard !reduceMotion else { return }
        withAnimation(.linear(duration: AppDuration.shimmer).repeatForever(autoreverses: false)) {
            isAnimating = true
        }
    }
}

extension View {
    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}
