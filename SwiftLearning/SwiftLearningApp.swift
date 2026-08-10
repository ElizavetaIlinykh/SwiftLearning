import SwiftUI

@main
struct SwiftLearningApp: App {
    @StateObject private var progressStore = LearningProgressStore()
    @State private var dependencies = AppDependenciesAssembler.assemble()
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            MainTabView(dependencies: dependencies)
                .environment(router)
                .environmentObject(progressStore)
        }
    }
}
