import Combine
import Foundation

enum LessonsLoadingState: Equatable {
    case idle
    case loading
    case loaded([LessonSummary])
    case failed(String)
}

@MainActor
final class LessonsManager: ObservableObject {
    @Published private(set) var state: LessonsLoadingState = .idle
    @Published private(set) var hasMore = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var loadMoreError: String?

    private let lessonsService: LessonsServicing
    private let pageLimit = 20
    private var loadedLessons: [LessonSummary] = []
    private var currentOffset = 0

    init(lessonsService: LessonsServicing) {
        self.lessonsService = lessonsService
    }

    func loadLessons() async {
        guard state != .loading else { return }

        state = .loading
        hasMore = false
        isLoadingMore = false
        loadMoreError = nil
        currentOffset = 0

        do {
            let response = try await lessonsService.fetchLessons(offset: currentOffset, limit: pageLimit)
            loadedLessons = response.items
            currentOffset = response.offset + response.items.count
            hasMore = response.hasMore && !response.items.isEmpty
            state = .loaded(loadedLessons)
        } catch {
            loadedLessons = []
            state = .failed(error.localizedDescription)
        }
    }

    func loadMoreLessonsIfNeeded(currentLessonID: String) async {
        guard shouldLoadMore(currentLessonID: currentLessonID) else { return }
        await loadMoreLessons()
    }

    func retryLoadMoreLessons() async {
        await loadMoreLessons()
    }

    private func loadMoreLessons() async {
        guard hasMore, !isLoadingMore else { return }

        isLoadingMore = true
        loadMoreError = nil

        do {
            let response = try await lessonsService.fetchLessons(
                offset: currentOffset,
                limit: pageLimit
            )
            currentOffset = response.offset + response.items.count

            if response.items.isEmpty {
                hasMore = false
            } else {
                loadedLessons.appendUnique(response.items)
                hasMore = response.hasMore
            }

            state = .loaded(loadedLessons)
        } catch {
            loadMoreError = error.localizedDescription
        }

        isLoadingMore = false
    }

    private func shouldLoadMore(currentLessonID: String) -> Bool {
        guard hasMore, !isLoadingMore else { return false }
        let orderedLessons = loadedLessons.sorted { $0.order < $1.order }
        guard let index = orderedLessons.firstIndex(where: { $0.id == currentLessonID }) else { return false }
        return index >= max(orderedLessons.count - 5, 0)
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
