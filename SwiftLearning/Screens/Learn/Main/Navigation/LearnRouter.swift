import Foundation
import Observation

@Observable
final class LearnRouter {
    enum Route: Hashable {
        case lesson(id: String, totalLessonsCount: Int)
        case quiz(lessonID: String)
        case codeTask(lessonID: String)
        case result(lessonID: String)
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
}
