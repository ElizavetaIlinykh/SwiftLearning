import Combine
import Foundation

enum LessonsMoreLoadingState: Equatable {
    case idle
    case loading
    case failed(String)
}

enum LessonsLoadingState: Equatable {
    case idle
    case loading
    case loaded(
        lessons: [LessonSummary],
        moreLoadingState: LessonsMoreLoadingState
    )
    case failed(String)
}

@MainActor
final class LessonsManager: ObservableObject {
    private enum Constants {
        static let pageLimit = 20
    }

    @Published private(set) var state: LessonsLoadingState = .idle

    private let pageLoader: PaginationLoader<LessonSummary>

    private var loadedLessons: [LessonSummary] = []
    private var hasMore = false
    private var moreLoadingState: LessonsMoreLoadingState = .idle

    var hasMoreToFetch: Bool {
        hasMore
    }

    init(lessonsService: LessonsServicing) {
        self.pageLoader = PaginationLoader(
            contract: .init(limit: Constants.pageLimit)
        ) { offset, limit in
            let response = try await lessonsService.fetchLessons(
                offset: offset,
                limit: limit
            )
            return response.items
        }
    }

    func fetch() async {
        if loadedLessons.isEmpty {
            await fetchInitial()
        } else {
            await fetchNext()
        }
    }

    func refresh() async {
        await fetchInitial()
    }

    private func fetchInitial() async {
        guard !isLoading else {
            return
        }

        state = .loading

        do {
            let response = try await pageLoader.fetch()

            loadedLessons = response.result
            hasMore = response.hasNext
            moreLoadingState = .idle

            publishLoadedState()
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    private func fetchNext() async {
        guard hasMore else {
            return
        }

        guard !isLoading else {
            return
        }

        moreLoadingState = .loading
        publishLoadedState()

        do {
            let response = try await pageLoader.loadNext()

            loadedLessons.append(contentsOf: response.result)
            hasMore = response.hasNext
            moreLoadingState = .idle

            publishLoadedState()
        } catch {
            moreLoadingState = .failed(error.localizedDescription)
            publishLoadedState()
        }
    }

    private var isLoading: Bool {
        switch state {
        case .loading:
            return true

        case .loaded(_, let moreLoadingState):
            return moreLoadingState == .loading

        case .idle, .failed:
            return false
        }
    }

    private func publishLoadedState() {
        state = .loaded(
            lessons: loadedLessons,
            moreLoadingState: moreLoadingState
        )
    }
}
