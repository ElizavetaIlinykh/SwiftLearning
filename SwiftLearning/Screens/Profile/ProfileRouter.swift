import Foundation
import Observation

@Observable
final class ProfileRouter {
    enum Route: Hashable {
        case statistics
        case settings
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
