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
    @Published private(set) var state: LessonsLoadingState = .idle

    private let lessonsService: LessonsServicing
    private let pageLimit = 20
    private var loadedLessons: [LessonSummary] = []
    private var currentOffset = 0
    private var hasMore = false
    private var moreLoadingState: LessonsMoreLoadingState = .idle

    init(lessonsService: LessonsServicing) {
        self.lessonsService = lessonsService
    }

    func loadLessons() async {
        guard state != .loading else { return }

        state = .loading
        hasMore = false
        moreLoadingState = .idle
        currentOffset = 0

        do {
            let response = try await lessonsService.fetchLessons(offset: currentOffset, limit: pageLimit)
            loadedLessons = response.items
            currentOffset = response.offset + response.items.count
            hasMore = response.hasMore && !response.items.isEmpty
            publishLoadedState()
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
        guard hasMore, moreLoadingState != .loading else { return }

        moreLoadingState = .loading
        publishLoadedState()

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

            moreLoadingState = .idle
        } catch {
            moreLoadingState = .failed(error.localizedDescription)
        }

        publishLoadedState()
    }

    private func publishLoadedState() {
        state = .loaded(
            lessons: loadedLessons,
            moreLoadingState: moreLoadingState
        )
    }

    private func shouldLoadMore(currentLessonID: String) -> Bool {
        guard hasMore, moreLoadingState != .loading else { return false }
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
