import Combine
import Foundation

enum LessonsMoreLoadingState: Equatable {
    case idle(canFetchMore: Bool)
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
    private enum Constants {
        static let pageLimit = 20
    }

    @Published private(set) var state: LessonsLoadingState = .idle

    private let lessonsService: LessonsServicing
    private var loadedLessons: [LessonSummary] = []
    private var currentOffset = 0
    private var hasMore = false
    private var moreLoadingState: LessonsMoreLoadingState = .idle(canFetchMore: false)

    init(lessonsService: LessonsServicing) {
        self.lessonsService = lessonsService
    }

    func fetch() async {
        guard state != .loading, moreLoadingState != .loading else { return }

        if loadedLessons.isEmpty {
            await loadInitialPage()
        } else {
            await loadNextPage()
        }
    }

    func refresh() async {
        guard state != .loading, moreLoadingState != .loading else { return }

        resetPagination()
        await loadInitialPage()
    }

    private func loadInitialPage() async {
        state = .loading
        resetPagination()

        do {
            let response = try await lessonsService.fetchLessons(
                offset: currentOffset,
                limit: Constants.pageLimit
            )
            loadedLessons = response.items
            loadedLessons.sort { $0.order < $1.order }
            currentOffset = response.offset + response.items.count
            hasMore = response.hasMore && !response.items.isEmpty
            moreLoadingState = .idle(canFetchMore: hasMore)
            publishLoadedState()
        } catch {
            loadedLessons = []
            state = .failed(error.localizedDescription)
        }
    }

    private func loadNextPage() async {
        guard hasMore, moreLoadingState != .loading else { return }

        moreLoadingState = .loading
        publishLoadedState()

        defer {
            publishLoadedState()
        }

        do {
            let response = try await lessonsService.fetchLessons(
                offset: currentOffset,
                limit: Constants.pageLimit
            )
            currentOffset = response.offset + response.items.count

            if response.items.isEmpty {
                hasMore = false
            } else {
                loadedLessons.appendUnique(response.items)
                loadedLessons.sort { $0.order < $1.order }
                hasMore = response.hasMore
            }

            moreLoadingState = .idle(canFetchMore: hasMore)
        } catch {
            moreLoadingState = .failed(error.localizedDescription)
        }
    }

    private func resetPagination() {
        loadedLessons = []
        currentOffset = 0
        hasMore = false
        moreLoadingState = .idle(canFetchMore: false)
    }

    private func publishLoadedState() {
        state = .loaded(
            lessons: loadedLessons,
            moreLoadingState: moreLoadingState
        )
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
