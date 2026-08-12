import Combine
import Foundation

@MainActor
final class PracticeViewModel: ObservableObject {
    private let topicsManager: PracticeTopicsManager
    private var cancellables: Set<AnyCancellable> = []

    var state: PracticeTopicsLoadingState {
        topicsManager.state
    }

    var topics: [PracticeCategory] {
        guard case .loaded(let topics) = state else { return [] }
        return topics.sorted { $0.order < $1.order }
    }

    init(topicsManager: PracticeTopicsManager) {
        self.topicsManager = topicsManager
        bindTopicsManagerUpdates()
    }

    func loadTopics() async {
        await topicsManager.loadTopics()
    }

    private func bindTopicsManagerUpdates() {
        topicsManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
