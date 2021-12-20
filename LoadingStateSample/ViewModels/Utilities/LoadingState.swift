import Foundation

enum LoadingState: Equatable {
    case idle
    case loading
    case failed(Error)
    case loaded

    static func ==(lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case
            (.idle, .idle),
            (.loading, .loading),
            (.failed, .failed),
            (.loaded, .loaded): return true
        default: return false
        }
    }
}
