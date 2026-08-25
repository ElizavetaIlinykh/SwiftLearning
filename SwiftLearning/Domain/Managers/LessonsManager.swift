import Foundation

enum LessonsMoreLoadingState {
    case idle
    case loading
    case failed(Error)
}

/// Coordinates lesson list loading and pagination.
@MainActor
final class LessonsManager {
    // MARK: - Private properties -

    private enum Constants {
        static let pageLimit = 20
    }

    private let pageLoader: PaginationLoader<LessonSummary>

    /// Cached lessons from all pages loaded so far.
    private var loadedLessons: [LessonSummary] = []

    /// Indicates whether the backend returned enough items to request another page.
    private var hasMore = false

    /// The currently running request. Regular requests are skipped while it exists; refresh cancels it.
    private var currentTask: Task<[LessonSummary], Error>?

    // MARK: - Public properties -

    private(set) var moreLoadingState: LessonsMoreLoadingState = .idle

    // MARK: - Init -

    /// Creates a manager backed by the provided lessons service.
    ///
    /// - Parameter lessonsService: Service used by `PaginationLoader` to fetch lesson pages.
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

    /// Loads the first page if lessons have not been loaded yet.
    ///
    /// Repeated calls return the cached lessons. If another request is already running,
    /// this method returns the currently cached lessons without starting a new request.
    ///
    /// - Returns: The current lessons cache after the operation completes.
    func fetch() async throws -> [LessonSummary] {
        guard loadedLessons.isEmpty else {
            return loadedLessons
        }

        guard currentTask == nil else {
            return loadedLessons
        }

        moreLoadingState = .idle
        return try await performInitialFetch()
    }

    /// Loads the next page and appends it to the existing lessons cache.
    ///
    /// The manager decides whether another page can be loaded using its internal
    /// pagination state. If there is no next page, or another request is already running,
    /// this method returns the current cache unchanged.
    ///
    /// - Returns: The full lessons cache after the operation completes.
    func loadMore() async throws -> [LessonSummary] {
        guard hasMore else {
            moreLoadingState = .idle
            return loadedLessons
        }

        guard currentTask == nil else {
            return loadedLessons
        }

        moreLoadingState = .loading

        do {
            let lessons = try await performLoadMore()
            moreLoadingState = .idle
            return lessons
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
    /// Refresh replaces the current cache with the newly fetched first page and resets
    /// pagination through `PaginationLoader.fetch()`.
    ///
    /// - Returns: The refreshed lessons cache.
    func refresh() async throws -> [LessonSummary] {
        await cancelCurrentTask()
        moreLoadingState = .idle

        return try await performInitialFetch()
    }

    // MARK: - Private methods -

    private func performInitialFetch() async throws -> [LessonSummary] {
        let task = Task { @MainActor in
            let response = try await pageLoader.fetch()

            // A refresh can cancel this task after the network call returns but before cache mutation.
            try Task.checkCancellation()

            loadedLessons = response.result
            hasMore = response.hasNext

            return loadedLessons
        }

        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
    }

    private func performLoadMore() async throws -> [LessonSummary] {
        let task = Task { @MainActor in
            let response = try await pageLoader.loadNext()

            // Prevent cancelled loadMore results from appending stale items after refresh was requested.
            try Task.checkCancellation()

            loadedLessons.append(
                contentsOf: response.result
            )
            hasMore = response.hasNext

            return loadedLessons
        }

        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
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
