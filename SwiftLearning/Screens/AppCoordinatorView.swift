import SwiftUI

struct AppCoordinatorView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    // MARK: - Private properties -

    @ObservedObject private var session: SessionState

    // MARK: - Init -

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        session = dependencies.session
    }

    // MARK: - Public properties -

    var body: some View {
        Group {
            switch session.status {
            case .unknown:
                ProgressView("Checking session")
            case .authenticated:
                MainCoordinatorView(dependencies: dependencies)
            case .unauthenticated:
                AuthCoordinatorView(dependencies: dependencies)
            }
        }
        .task {
            await session.restoreSession()
        }
    }
}

#Preview {
    AppCoordinatorView(dependencies: AppDependenciesAssembler.assemble())
}
