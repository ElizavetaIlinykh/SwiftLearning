import Combine
import Foundation

typealias PracticeTasksLoadingState = LoadingState<[PracticeTask]>

@MainActor
final class PracticeTasksManager: ObservableObject {
    // MARK: - Private properties -

    @Published private(set) var state: PracticeTasksLoadingState = .idle
    @Published private(set) var hasMore = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var loadMoreError: String?
    private let topicID: String
    private let practiceService: PracticeServicing
    private let pageLimit = 20
    private var loadedTasks: [PracticeTask] = []
    private var currentOffset = 0

    // MARK: - Init -

    init(
        topicID: String,
        practiceService: PracticeServicing
    ) {
        self.topicID = topicID
        self.practiceService = practiceService
    }

    // MARK: - Public methods -

    func loadTasks() async {
        guard state != .loading else { return }

        state = .loading
        hasMore = false
        isLoadingMore = false
        loadMoreError = nil
        currentOffset = 0

        do {
            let response = try await practiceService.fetchTasks(
                topicID: topicID,
                offset: currentOffset,
                limit: pageLimit
            )
            loadedTasks = response.items
            currentOffset = response.offset + response.items.count
            hasMore = response.hasMore && !response.items.isEmpty
            state = .loaded(loadedTasks)
        } catch {
            loadedTasks = []
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func loadMoreTasksIfNeeded(currentTaskID: String) async {
        guard shouldLoadMore(currentTaskID: currentTaskID) else { return }
        await loadMoreTasks()
    }

    func loadMoreTasks() async {
        guard hasMore, !isLoadingMore else { return }

        isLoadingMore = true
        loadMoreError = nil

        do {
            let response = try await practiceService.fetchTasks(
                topicID: topicID,
                offset: currentOffset,
                limit: pageLimit
            )
            currentOffset = response.offset + response.items.count

            if response.items.isEmpty {
                hasMore = false
            } else {
                loadedTasks.appendUnique(response.items)
                hasMore = response.hasMore
            }

            state = .loaded(loadedTasks)
        } catch {
            loadMoreError = UserFacingErrorMessage.message(for: error)
        }

        isLoadingMore = false
    }

    // MARK: - Private methods -

    private func shouldLoadMore(currentTaskID: String) -> Bool {
        guard hasMore, !isLoadingMore else { return false }
        let orderedTasks = loadedTasks.sorted { $0.order < $1.order }
        guard let index = orderedTasks.firstIndex(where: { $0.id == currentTaskID }) else { return false }
        return index >= max(orderedTasks.count - 5, 0)
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
