import Combine
import Foundation

@MainActor
final class PracticeSessionViewModel: ObservableObject {
    private let tasksManager: PracticeTasksManager
    private var cancellables: Set<AnyCancellable> = []

    let topicID: String
    let topicTitle: String

    var state: PracticeTasksLoadingState {
        tasksManager.state
    }

    var tasks: [PracticeTask] {
        guard case .loaded(let tasks) = state else { return [] }
        return tasks.sorted { $0.order < $1.order }
    }

    init(
        topicID: String,
        topicTitle: String,
        tasksManager: PracticeTasksManager
    ) {
        self.topicID = topicID
        self.topicTitle = topicTitle
        self.tasksManager = tasksManager
        bindTasksManagerUpdates()
    }

    func loadTasks() async {
        await tasksManager.loadTasks()
    }

    private func bindTasksManagerUpdates() {
        tasksManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
