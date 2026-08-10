import SwiftUI

@main
struct SwiftLearningApp: App {
    @StateObject private var progressStore = LearningProgressStore()
    @State private var dependencies = AppDependenciesAssembler.assemble()

    var body: some Scene {
        WindowGroup {
            MainTabView(dependencies: dependencies)
                .environmentObject(progressStore)
        }
    }
}
