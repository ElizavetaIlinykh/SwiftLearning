import Combine
import Foundation

@MainActor
final class PracticeViewModel: ObservableObject {
    // MARK: - Private properties -

    private let topicsManager: PracticeTopicsManager
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public properties -

    @Published private(set) var state: PracticeTopicsLoadingState
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

    init(topicsManager: PracticeTopicsManager) {
        self.topicsManager = topicsManager
        state = topicsManager.state

        bindTopicsManager()
    }

    // MARK: - Public methods -

    func loadTopics() async {
        await topicsManager.fetch()
    }

    func loadMoreTopicsIfNeeded(currentTopicID: String) async {
        await topicsManager.loadMoreTopicsIfNeeded(currentTopicID: currentTopicID)
    }

    func retryLoadMoreTopics() async {
        await topicsManager.loadMore()
    }

    func refreshTopics() async {
        await topicsManager.refresh()
    }

    // MARK: - Private methods -

    private func bindTopicsManager() {
        topicsManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
