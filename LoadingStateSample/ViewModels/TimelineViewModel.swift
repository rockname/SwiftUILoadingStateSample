import Foundation
import SwiftUI

@MainActor
class TimelineViewModel: ObservableObject {
    private let postRepository: PostRepository

    @Published var snackbarConfiguration = Snackbar.Configuration(
        text: "",
        isShown: false
    )

    @Published private(set) var timeline = [Post]()
    @Published private(set) var loadingAtFirstState: LoadingState = .idle
    @Published private(set) var loadingOlderState: LoadingState = .idle

    let placeholder: [Post] = (0..<5).map {
        Post(
            id: $0,
            userName: Array(repeating: " ", count: 10).joined(),
            iconURL: URL(string: "https://example.com/sample.png")!,
            content: Array(repeating: " ", count: 30).joined()
        )
    }

    init(postRepository: PostRepository = .init()) {
        self.postRepository = postRepository
    }

    func onAppear() {
        fetchTimelineAtFirst()
    }

    func onPostAppear(post: Post) {
        if timeline.firstIndex(where: { $0.id == post.id }) == timeline.endIndex - 1 {
            fetchTimelineOlder()
        }
    }

    func onRefresh() async {
        await fetchTimelineNewer()
    }

    func onLoadingAtFirstRetry() {
        fetchTimelineAtFirst()
    }

    func onLoadingOlderRetry() {
        fetchTimelineOlder()
    }

    func onPostButtonTapped() {
        // TODO: Post something
    }

    private func fetchTimelineAtFirst() {
        loadingAtFirstState = .loading
        Task {
            do {
                let fetched = try await postRepository.fetchTimeline()
                loadingAtFirstState = .loaded
                timeline = fetched
            } catch {
                loadingAtFirstState = .failed(error)
            }
        }
    }

    private func fetchTimelineNewer() async {
        do {
            let fetched = try await postRepository.fetchTimeline(after: timeline.first!.id)
            timeline = fetched + timeline
        } catch {
            showSnackbar(text: "Failed to load newer timeline")
        }
    }

    private func fetchTimelineOlder() {
        loadingOlderState = .loading
        Task {
            do {
                let fetched = try await postRepository.fetchTimeline(before: timeline.last!.id)
                loadingOlderState = .loaded
                timeline = timeline + fetched
            } catch {
                loadingOlderState = .failed(error)
            }
        }
    }

    private func showSnackbar(text: String) {
        snackbarConfiguration = .init(text: text, isShown: true)
    }
}
