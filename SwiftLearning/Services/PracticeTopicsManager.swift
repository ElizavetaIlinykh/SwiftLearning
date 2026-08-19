import Combine
import Foundation

enum PracticeTopicsMoreLoadingState: Equatable {
    case idle
    case loading
    case failed(String)
}

enum PracticeTopicsLoadingState: Equatable {
    case idle
    case loading
    case loaded(
        topics: [PracticeCategory],
        moreLoadingState: PracticeTopicsMoreLoadingState
    )
    case failed(String)
}

@MainActor
final class PracticeTopicsManager: ObservableObject {
    // MARK: - Private properties -

    private enum Constants {
        static let pageLimit = 20
    }

    @Published private(set) var state: PracticeTopicsLoadingState = .idle

    private let pageLoader: PaginationLoader<PracticeCategory>

    private var loadedTopics: [PracticeCategory] = []
    private var hasMore = false
    private var moreLoadingState: PracticeTopicsMoreLoadingState = .idle
    private var isRefreshing = false

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

    // MARK: - Init -

    init(practiceService: PracticeServicing) {
        pageLoader = PaginationLoader(
            contract: .init(
                limit: Constants.pageLimit
            )
        ) { offset, limit in
            let response = try await practiceService.fetchTopics(
                offset: offset,
                limit: limit
            )

            return response.items
        }
    }

    // MARK: - Public methods -

    func fetch() async {
        guard loadedTopics.isEmpty else {
            return
        }

        await fetchInitial()
    }

    func loadMoreTopicsIfNeeded(currentTopicID: String) async {
        guard shouldLoadMore(currentTopicID: currentTopicID) else {
            return
        }

        await fetchNext()
    }

    func loadMore() async {
        await fetchNext()
    }

    func refresh() async {
        guard !isRefreshing, !isLoading else {
            return
        }

        guard !loadedTopics.isEmpty else {
            await fetchInitial()
            return
        }

        isRefreshing = true
        defer {
            isRefreshing = false
        }

        do {
            let response = try await pageLoader.fetch()

            loadedTopics = response.result
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

            loadedTopics = response.result
            hasMore = response.hasNext
            moreLoadingState = .idle

            publishLoadedState()
        } catch is CancellationError {
            return
        } catch {
            loadedTopics = []
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

            loadedTopics.append(
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

    private func shouldLoadMore(currentTopicID: String) -> Bool {
        guard hasMore, !isLoading else {
            return false
        }

        let orderedTopics = loadedTopics.sorted { $0.order < $1.order }
        guard let index = orderedTopics.firstIndex(where: { $0.id == currentTopicID }) else {
            return false
        }

        return index >= max(orderedTopics.count - 5, 0)
    }

    private func publishLoadedState() {
        state = .loaded(
            topics: loadedTopics,
            moreLoadingState: moreLoadingState
        )
    }
}
