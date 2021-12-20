import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                TimelineView(viewModel: .init())
            } label: {
                Text("Timeline")
            }
        }
    }
}
