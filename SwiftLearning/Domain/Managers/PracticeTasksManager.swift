import Foundation

struct PracticeTasksPage: Equatable {
    // MARK: - Public properties -

    let tasks: [PracticeTask]
    let hasMore: Bool
}

typealias PracticeTasksLoadingState = LoadingState<[PracticeTask]>

/// Coordinates practice task loading and pagination for one topic.
///
/// The manager owns page accumulation, duplicate filtering, and next-page checks.
/// UI state is handled by `PracticeSessionViewModel`.
@MainActor
final class PracticeTasksManager {
    // MARK: - Private properties -

    private enum Constants {
        static let pageLimit = 20
        static let prefetchThreshold = 5
    }

    private let topicID: String
    private let practiceService: PracticeServicing
    private let pageLoader: PaginationLoader<PracticeTask>

    private var loadedTasks: [PracticeTask] = []
    private var hasMoreTasks = false
    private var currentTask: Task<PracticeTasksPage, Error>?

    // MARK: - Init -

    /// Creates a manager for a practice topic.
    ///
    /// - Parameters:
    ///   - topicID: Identifier of the topic whose tasks should be loaded.
    ///   - practiceService: Service used to fetch task pages.
    init(
        topicID: String,
        practiceService: PracticeServicing
    ) {
        self.topicID = topicID
        self.practiceService = practiceService
        pageLoader = PaginationLoader(
            contract: .init(limit: Constants.pageLimit),
            pageFetcher: { offset, limit in
                let response = try await practiceService.fetchTasks(
                    topicID: topicID,
                    offset: offset,
                    limit: limit
                )

                return PaginationResponse(
                    result: response.items,
                    hasNext: response.hasMore && !response.items.isEmpty
                )
            }
        )
    }

    // MARK: - Public methods -

    /// Loads the first task page and resets pagination.
    ///
    /// - Returns: A snapshot containing loaded tasks and next-page availability.
    func loadTasks() async throws -> PracticeTasksPage {
        guard currentTask == nil else {
            return currentPage
        }

        return try await performInitialFetch()
    }

    /// Loads the next page when the current task is close to the end of the cache.
    ///
    /// - Parameter currentTaskID: Task currently visible to the user.
    /// - Returns: The current page snapshot after the operation completes.
    func loadMoreTasksIfNeeded(currentTaskID: String) async throws -> PracticeTasksPage {
        guard shouldLoadMore(currentTaskID: currentTaskID) else {
            return currentPage
        }

        return try await loadMoreTasks()
    }

    /// Loads and appends the next task page when available.
    ///
    /// - Returns: The current page snapshot after the operation completes.
    func loadMoreTasks() async throws -> PracticeTasksPage {
        guard hasMoreTasks else {
            return currentPage
        }

        guard currentTask == nil else {
            return currentPage
        }

        return try await performLoadMore()
    }

    /// Saves the completed practice topic result.
    ///
    /// - Parameters:
    ///   - correctAnswersCount: Number of correctly answered tasks.
    ///   - totalAnswersCount: Total number of answered tasks.
    /// - Returns: Updated practice progress returned by the backend.
    func completeTopic(
        correctAnswersCount: Int,
        totalAnswersCount: Int
    ) async throws -> PracticeProgress {
        try await practiceService.completeTopic(
            topicID: topicID,
            correctAnswersCount: correctAnswersCount,
            totalAnswersCount: totalAnswersCount
        )
    }

    // MARK: - Private properties -

    private var currentPage: PracticeTasksPage {
        PracticeTasksPage(
            tasks: loadedTasks,
            hasMore: hasMoreTasks
        )
    }

    // MARK: - Private methods -

    private func performInitialFetch() async throws -> PracticeTasksPage {
        let task = Task { @MainActor in
            let response = try await pageLoader.fetch()

            try Task.checkCancellation()

            loadedTasks = response.result
            hasMoreTasks = response.hasNext

            return currentPage
        }

        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
    }

    private func performLoadMore() async throws -> PracticeTasksPage {
        let task = Task { @MainActor in
            let response = try await pageLoader.loadNext()

            try Task.checkCancellation()

            if response.result.isEmpty {
                hasMoreTasks = false
            } else {
                loadedTasks.appendUnique(response.result)
                hasMoreTasks = response.hasNext
            }

            return currentPage
        }

        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
    }

    private func shouldLoadMore(currentTaskID: String) -> Bool {
        guard hasMoreTasks, currentTask == nil else { return false }
        let orderedTasks = loadedTasks.sorted { $0.order < $1.order }
        guard let index = orderedTasks.firstIndex(where: { $0.id == currentTaskID }) else { return false }
        return index >= max(orderedTasks.count - Constants.prefetchThreshold, 0)
    }
}

private extension Array where Element: Identifiable {
    mutating func appendUnique(_ newElements: [Element]) where Element.ID: Hashable {
        var existingIDs = Set(map(\.id))
        for element in newElements where existingIDs.insert(element.id).inserted {
            append(element)
        }
    }
}
