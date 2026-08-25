import Foundation
import Observation

@Observable
final class PracticeRouter {
    enum Route: Hashable {
        case exercise(id: String, title: String, attemptID: UUID)
        case result(topicID: String, topicTitle: String, progress: PracticeProgress)
    }

    // MARK: - Public properties -

    var path: [Route] = []

    // MARK: - Public methods -

    func navigate(to route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func restartPractice(topicID: String, topicTitle: String) {
        path = [.exercise(id: topicID, title: topicTitle, attemptID: UUID())]
    }
}
