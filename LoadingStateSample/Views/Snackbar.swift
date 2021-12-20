import SwiftUI

struct Snackbar: View {
    struct Configuration {
        var text: String
        var isShown: Bool
    }

    @State private var opacity = 0.0

    @Binding private var isShown: Bool
    @Binding private var text: String
    private let presentingView: AnyView

    init<Presenting>(
        presentingView: Presenting,
        isShown: Binding<Bool>,
        text: Binding<String>
    ) where Presenting: View {
        self.presentingView = AnyView(presentingView)
        _isShown = isShown
        _text = text
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                presentingView
                VStack {
                    Spacer()
                    if isShown {
                        Text(text)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geometry.size.width * 0.9, height: 50)
                            .shadow(radius: 4)
                            .background(Color.black)
                            .cornerRadius(8)
                            .offset(x: 0, y: -20)
                            .opacity(opacity)
                            .animation(.linear, value: opacity)
                            .onAppear {
                                opacity = 1.0
                                Task {
                                    await Task.sleep(3 * 1_000_000_000)
                                    withAnimation {
                                        isShown = false
                                        opacity = 0.0
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}

extension View {
    func snackbar(configuration: Binding<Snackbar.Configuration>) -> some View {
        Snackbar(
            presentingView: self,
            isShown: configuration.isShown,
            text: configuration.text
        )
    }
}
