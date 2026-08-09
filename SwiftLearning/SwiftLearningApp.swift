import SwiftUI

@main
struct SwiftLearningApp: App {
    @StateObject private var progressStore = LearningProgressStore()
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            MainTabView(dependencies: dependencies)
                .environmentObject(progressStore)
        }
    }
}
