import Foundation
import Observation

@Observable
final class AuthRouter {
    enum Route: Hashable {
        case registration
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
