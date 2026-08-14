import Combine
import Foundation

enum PracticeTopicsLoadingState: Equatable {
    case idle
    case loading
    case loaded([PracticeCategory])
    case failed(String)
}

@MainActor
final class PracticeTopicsManager: ObservableObject {
    @Published private(set) var state: PracticeTopicsLoadingState = .idle
    @Published private(set) var hasMore = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var loadMoreError: String?

    private let practiceService: PracticeServicing
    private let pageLimit = 20
    private var loadedTopics: [PracticeCategory] = []
    private var currentOffset = 0

    init(practiceService: PracticeServicing) {
        self.practiceService = practiceService
    }

    func loadTopics() async {
        guard state != .loading else { return }

        state = .loading
        hasMore = false
        isLoadingMore = false
        loadMoreError = nil
        currentOffset = 0

        do {
            let response = try await practiceService.fetchTopics(offset: currentOffset, limit: pageLimit)
            loadedTopics = response.items
            currentOffset = response.offset + response.items.count
            hasMore = response.hasMore && !response.items.isEmpty
            state = .loaded(loadedTopics)
        } catch {
            loadedTopics = []
            state = .failed(error.localizedDescription)
        }
    }

    func loadMoreTopicsIfNeeded(currentTopicID: String) async {
        guard shouldLoadMore(currentTopicID: currentTopicID) else { return }
        await loadMoreTopics()
    }

    func retryLoadMoreTopics() async {
        await loadMoreTopics()
    }

    private func loadMoreTopics() async {
        guard hasMore, !isLoadingMore else { return }

        isLoadingMore = true
        loadMoreError = nil

        do {
            let response = try await practiceService.fetchTopics(
                offset: currentOffset,
                limit: pageLimit
            )
            currentOffset = response.offset + response.items.count

            if response.items.isEmpty {
                hasMore = false
            } else {
                loadedTopics.appendUnique(response.items)
                hasMore = response.hasMore
            }

            state = .loaded(loadedTopics)
        } catch {
            loadMoreError = error.localizedDescription
        }

        isLoadingMore = false
    }

    private func shouldLoadMore(currentTopicID: String) -> Bool {
        guard hasMore, !isLoadingMore else { return false }
        let orderedTopics = loadedTopics.sorted { $0.order < $1.order }
        guard let index = orderedTopics.firstIndex(where: { $0.id == currentTopicID }) else { return false }
        return index >= max(orderedTopics.count - 5, 0)
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
