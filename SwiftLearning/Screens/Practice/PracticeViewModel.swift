import Combine
import Foundation

@MainActor
final class PracticeViewModel: ObservableObject {
    private let topicsManager: PracticeTopicsManager
    private var cancellables: Set<AnyCancellable> = []

    @Published private(set) var state: PracticeTopicsLoadingState
    @Published private(set) var isLoadingMore: Bool
    @Published private(set) var loadMoreError: String?

    var topics: [PracticeCategory] {
        guard case .loaded(let topics) = state else { return [] }
        return topics.sorted { $0.order < $1.order }
    }

    init(topicsManager: PracticeTopicsManager) {
        self.topicsManager = topicsManager
        self.state = topicsManager.state
        self.isLoadingMore = topicsManager.isLoadingMore
        self.loadMoreError = topicsManager.loadMoreError

        bindTopicsManager()
    }

    func loadTopics() async {
        await topicsManager.loadTopics()
    }

    func loadMoreTopicsIfNeeded(currentTopicID: String) async {
        await topicsManager.loadMoreTopicsIfNeeded(currentTopicID: currentTopicID)
    }

    func retryLoadMoreTopics() async {
        await topicsManager.retryLoadMoreTopics()
    }

    private func bindTopicsManager() {
        topicsManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)

        topicsManager.$isLoadingMore
            .sink { [weak self] isLoadingMore in
                self?.isLoadingMore = isLoadingMore
            }
            .store(in: &cancellables)

        topicsManager.$loadMoreError
            .sink { [weak self] loadMoreError in
                self?.loadMoreError = loadMoreError
            }
            .store(in: &cancellables)
    }
}
