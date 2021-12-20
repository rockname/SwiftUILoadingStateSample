import Foundation

struct PostRepository {
    enum APIError: Error {
        case unknown
    }

    private let timeline = (1...200).map {
        Post(
            id: $0,
            userName: "rockname",
            iconURL: URL(string: "https://pbs.twimg.com/profile_images/936426050254397445/EopjxE36_400x400.jpg")!,
            content: "This is a post \($0)."
        )
    }.sorted(by: { $0.id > $1.id })

    func fetchTimeline(limit: Int = 20) async throws -> [Post] {
        await Task.sleep(3 * 1_000_000_000)

        if Bool.random() {
            throw APIError.unknown
        }

        return Array(timeline[100..<100+limit])
    }

    func fetchTimeline(after cursor: Int, limit: Int = 20) async throws -> [Post] {
        await Task.sleep(3 * 1_000_000_000)

        if Bool.random() {
            throw APIError.unknown
        }

        let index = timeline.firstIndex { $0.id == cursor }!
        guard index >= 0 else { return [] }

        return Array(timeline[max(index - limit, 0)..<index])
    }

    func fetchTimeline(before cursor: Int, limit: Int = 20) async throws -> [Post] {
        await Task.sleep(3 * 1_000_000_000)

        if Bool.random() {
            throw APIError.unknown
        }

        let index = timeline.firstIndex { $0.id == cursor }!
        guard index < timeline.count - 1 else { return [] }

        return Array(timeline[index+1..<min(index+limit, timeline.count - 1)])
    }
}
