import Combine
import Foundation

@MainActor
final class PracticeViewModel: ObservableObject {
    // MARK: - Private properties -

    private let topicsManager: PracticeTopicsManager
    private let router: AppRouter

    // MARK: - Public properties -

    @Published private(set) var state: PracticeTopicsLoadingState = .idle

    var topics: [PracticeCategory] {
        guard case let .loaded(topics, _) = state else { return [] }
        return topics.sorted { $0.order < $1.order }
    }

    var loadMoreState: LoadMoreView.State {
        guard case let .loaded(_, moreLoadingState) = state else { return .idle }
        switch moreLoadingState {
        case .loading:
            return .loading
        case let .failed(message):
            return .error(message)
        case .idle:
            return .idle
        }
    }

    // MARK: - Init -

    init(
        topicsManager: PracticeTopicsManager,
        router: AppRouter
    ) {
        self.topicsManager = topicsManager
        self.router = router
    }

    // MARK: - Public methods -

    func loadTopics() async {
        if topics.isEmpty {
            state = .loading
        }

        do {
            let topics = try await topicsManager.fetch()
            setLoadedState(topics: topics)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func loadMoreTopicsIfNeeded(currentTopicID: String) async {
        setLoadMoreState(.loading)

        do {
            let topics = try await topicsManager.loadMoreIfNeeded(currentTopicID: currentTopicID)
            setLoadedState(topics: topics)
        } catch is CancellationError {
            setLoadMoreState(.idle)
        } catch {
            setLoadMoreState(.failed(UserFacingErrorMessage.message(for: error)))
        }
    }

    func retryLoadMoreTopics() async {
        setLoadMoreState(.loading)

        do {
            let topics = try await topicsManager.loadMore()
            setLoadedState(topics: topics)
        } catch is CancellationError {
            setLoadMoreState(.idle)
        } catch {
            setLoadMoreState(.failed(UserFacingErrorMessage.message(for: error)))
        }
    }

    func refreshTopics() async {
        do {
            let topics = try await topicsManager.refresh()
            setLoadedState(topics: topics)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func selectTopic(_ topic: PracticeCategory) {
        router.push(.exercise(id: topic.id, title: topic.title, attemptID: UUID()))
    }

    // MARK: - Private methods -

    private func setLoadedState(
        topics: [PracticeCategory],
        moreLoadingState: PracticeTopicsMoreLoadingState = .idle
    ) {
        state = .loaded(
            topics: topics,
            moreLoadingState: moreLoadingState
        )
    }

    private func setLoadMoreState(_ moreLoadingState: PracticeTopicsMoreLoadingState) {
        guard case let .loaded(topics, _) = state else {
            return
        }

        setLoadedState(
            topics: topics,
            moreLoadingState: moreLoadingState
        )
    }
}
