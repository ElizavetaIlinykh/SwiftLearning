import SwiftUI

@main
struct SwiftLearningApp: App {
    // MARK: - Private properties -

    // MARK: - Public properties -

    @State private var dependencies = AppDependenciesAssembler.assemble()
    @State private var router = AppRouter()
    var body: some Scene {
        WindowGroup {
            AppRootView(dependencies: dependencies)
                .environment(router)
        }
    }
}

private struct AppRootView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    // MARK: - Private properties -

    // MARK: - Init -

    @ObservedObject private var session: SessionState
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        session = dependencies.session
    }

    var body: some View {
        Group {
            switch session.status {
            case .unknown:
                ProgressView("Checking session")
            case .authenticated:
                MainTabView(dependencies: dependencies)
            case .unauthenticated:
                AuthRootView(session: session)
            }
        }
        .task {
            await session.restoreSession()
        }
    }
}
