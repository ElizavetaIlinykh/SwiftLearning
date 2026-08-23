import Foundation

enum PracticeTopicsMoreLoadingState {
    case idle
    case loading
    case failed(Error)
}

/// Coordinates practice topic loading and pagination.
///
/// `PracticeTopicsManager` owns topic paging, caching, and next-page checks.
/// UI state is handled by `PracticeViewModel`.
@MainActor
final class PracticeTopicsManager {
    // MARK: - Private properties -

    private enum Constants {
        static let pageLimit = 20
        static let prefetchThreshold = 5
    }

    private let pageLoader: PaginationLoader<PracticeCategory>

    /// Cached topics from all loaded pages.
    private var loadedTopics: [PracticeCategory] = []

    /// Indicates whether another topic page is available.
    private var hasMore = false

    /// The currently running request. Regular requests are skipped while it exists.
    private var currentTask: Task<[PracticeCategory], Error>?

    // MARK: - Public properties -

    private(set) var moreLoadingState: PracticeTopicsMoreLoadingState = .idle

    // MARK: - Init -

    /// Creates a manager backed by the provided practice service.
    ///
    /// - Parameter practiceService: Service used by `PaginationLoader` to fetch topic pages.
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

    /// Loads the first page if topics have not been loaded yet.
    ///
    /// - Returns: The current topic cache after the operation completes.
    func fetch() async throws -> [PracticeCategory] {
        guard loadedTopics.isEmpty else {
            return loadedTopics
        }

        guard currentTask == nil else {
            return loadedTopics
        }

        moreLoadingState = .idle
        return try await performInitialFetch()
    }

    /// Loads the next topic page if the current item is close to the end of the cache.
    ///
    /// - Parameter currentTopicID: Topic currently visible to the user.
    /// - Returns: The current topic cache after the operation completes.
    func loadMoreIfNeeded(currentTopicID: String) async throws -> [PracticeCategory] {
        guard shouldLoadMore(currentTopicID: currentTopicID) else {
            return loadedTopics
        }

        return try await loadMore()
    }

    /// Loads and appends the next topic page when available.
    ///
    /// - Returns: The full topic cache after the operation completes.
    func loadMore() async throws -> [PracticeCategory] {
        guard hasMore else {
            moreLoadingState = .idle
            return loadedTopics
        }

        guard currentTask == nil else {
            return loadedTopics
        }

        moreLoadingState = .loading

        do {
            let topics = try await performLoadMore()
            moreLoadingState = .idle
            return topics
        } catch is CancellationError {
            moreLoadingState = .idle
            throw CancellationError()
        } catch {
            moreLoadingState = .failed(error)
            throw error
        }
    }

    /// Cancels any in-flight request and reloads the first page.
    ///
    /// - Returns: The refreshed topic cache.
    func refresh() async throws -> [PracticeCategory] {
        await cancelCurrentTask()
        moreLoadingState = .idle

        return try await performInitialFetch()
    }

    // MARK: - Private methods -

    private func performInitialFetch() async throws -> [PracticeCategory] {
        let task = Task { @MainActor in
            let response = try await pageLoader.fetch()

            try Task.checkCancellation()

            loadedTopics = response.result
            hasMore = response.hasNext

            return loadedTopics
        }

        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
    }

    private func performLoadMore() async throws -> [PracticeCategory] {
        let task = Task { @MainActor in
            let response = try await pageLoader.loadNext()

            try Task.checkCancellation()

            loadedTopics.append(
                contentsOf: response.result
            )
            hasMore = response.hasNext

            return loadedTopics
        }

        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
    }

    private func shouldLoadMore(currentTopicID: String) -> Bool {
        guard hasMore, currentTask == nil else {
            return false
        }

        let orderedTopics = loadedTopics.sorted { $0.order < $1.order }
        guard let index = orderedTopics.firstIndex(where: { $0.id == currentTopicID }) else {
            return false
        }

        return index >= max(orderedTopics.count - Constants.prefetchThreshold, 0)
    }

    private func cancelCurrentTask() async {
        guard let currentTask else {
            return
        }

        currentTask.cancel()

        do {
            _ = try await currentTask.value
        } catch {
            // Cancellation is expected here.
        }
    }
}
