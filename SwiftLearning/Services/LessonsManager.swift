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
    // MARK: - Private properties -

    private enum Constants {
        static let pageLimit = 20
    }

    @Published private(set) var state: LessonsLoadingState = .idle

    private let pageLoader: PaginationLoader<LessonSummary>

    private var loadedLessons: [LessonSummary] = []
    private var hasMore = false
    private var moreLoadingState: LessonsMoreLoadingState = .idle
    private var isRefreshing = false

    // MARK: - Init -

    init(lessonsService: LessonsServicing) {
        pageLoader = PaginationLoader(
            contract: .init(
                limit: Constants.pageLimit
            )
        ) { offset, limit in
            let response = try await lessonsService.fetchLessons(
                offset: offset,
                limit: limit
            )

            return response.items
        }
    }

    // MARK: - Public methods -

    func fetch() async {
        guard loadedLessons.isEmpty else {
            return
        }

        await fetchInitial()
    }

    func loadMore() async {
        await fetchNext()
    }

    func refresh() async {
        guard !isRefreshing, !isLoading else {
            return
        }

        guard !loadedLessons.isEmpty else {
            await fetchInitial()
            return
        }

        isRefreshing = true
        defer {
            isRefreshing = false
        }

        do {
            let response = try await pageLoader.fetch()

            loadedLessons = response.result
            hasMore = response.hasNext
            moreLoadingState = .idle

            publishLoadedState()
        } catch is CancellationError {
            return
        } catch {
            publishLoadedState()
        }
    }

    // MARK: - Private methods -

    private func fetchInitial() async {
        guard !isLoading, !isRefreshing else {
            return
        }

        state = .loading

        do {
            let response = try await pageLoader.fetch()

            loadedLessons = response.result
            hasMore = response.hasNext
            moreLoadingState = .idle

            publishLoadedState()
        } catch is CancellationError {
            return
        } catch {
            state = .failed(
                error.localizedDescription
            )
        }
    }

    private func fetchNext() async {
        guard hasMore, !isLoading, !isRefreshing else {
            return
        }

        moreLoadingState = .loading
        publishLoadedState()

        do {
            let response = try await pageLoader.loadNext()

            loadedLessons.append(
                contentsOf: response.result
            )

            hasMore = response.hasNext
            moreLoadingState = .idle

            publishLoadedState()
        } catch is CancellationError {
            return
        } catch {
            moreLoadingState = .failed(
                error.localizedDescription
            )

            publishLoadedState()
        }
    }

    private var isLoading: Bool {
        switch state {
        case .loading:
            true

        case let .loaded(_, moreLoadingState):
            moreLoadingState == .loading

        case .idle, .failed:
            false
        }
    }

    private func publishLoadedState() {
        state = .loaded(
            lessons: loadedLessons,
            moreLoadingState: moreLoadingState
        )
    }
}
