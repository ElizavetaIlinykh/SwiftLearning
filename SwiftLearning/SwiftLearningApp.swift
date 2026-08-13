import SwiftUI

@main
struct SwiftLearningApp: App {
    @StateObject private var progressStore = LearningProgressStore()
    @State private var dependencies = AppDependenciesAssembler.assemble()
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            AppRootView(dependencies: dependencies)
                .environment(router)
                .environmentObject(progressStore)
        }
    }
}

private struct AppRootView: View {
    let dependencies: AppDependencies
    @ObservedObject private var session: SessionState

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        self.session = dependencies.session
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
