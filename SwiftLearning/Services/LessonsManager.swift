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
    @Published private(set) var isLoadingMore = false
    @Published private(set) var loadMoreError: String?
    @Published private(set) var canFetchMoreLessons = false

    private let lessonsService: LessonsServicing
    private let pageLimit = 20
    private var loadedLessons: [LessonSummary] = []
    private var currentOffset = 0
    private var hasMore = false

    init(lessonsService: LessonsServicing) {
        self.lessonsService = lessonsService
    }

    func fetch() async {
        guard state != .loading, !isLoadingMore else { return }

        if loadedLessons.isEmpty {
            await loadInitialPage()
        } else {
            await loadNextPage()
        }
    }

    func refresh() async {
        guard state != .loading, !isLoadingMore else { return }

        resetPagination()
        await loadInitialPage()
    }

    private func loadInitialPage() async {
        state = .loading
        resetPagination()

        do {
            let response = try await lessonsService.fetchLessons(offset: currentOffset, limit: pageLimit)
            loadedLessons = response.items
            loadedLessons.sort { $0.order < $1.order }
            currentOffset = response.offset + response.items.count
            hasMore = response.hasMore && !response.items.isEmpty
            state = .loaded(loadedLessons)
        } catch {
            loadedLessons = []
            state = .failed(error.localizedDescription)
        }

        updateCanFetchMoreLessons()
    }

    private func loadNextPage() async {
        guard hasMore, !isLoadingMore else { return }

        isLoadingMore = true
        loadMoreError = nil
        updateCanFetchMoreLessons()

        defer {
            isLoadingMore = false
            updateCanFetchMoreLessons()
        }

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
                loadedLessons.sort { $0.order < $1.order }
                hasMore = response.hasMore
            }

            state = .loaded(loadedLessons)
        } catch {
            loadMoreError = error.localizedDescription
        }
    }

    private func resetPagination() {
        loadedLessons = []
        currentOffset = 0
        hasMore = false
        loadMoreError = nil
        canFetchMoreLessons = false
    }

    private func updateCanFetchMoreLessons() {
        canFetchMoreLessons = hasMore && !loadedLessons.isEmpty && state != .loading && !isLoadingMore
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
