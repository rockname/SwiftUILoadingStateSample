import SwiftUI

struct EaseInOutAnimation: ViewModifier {

    @State private var contentOpacity = 1.0

    func body(content: Content) -> some View {
        content
            .opacity(contentOpacity)
            .animation(
                .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                value: contentOpacity
            )
            .onAppear { contentOpacity = 0.3 }
    }
}
