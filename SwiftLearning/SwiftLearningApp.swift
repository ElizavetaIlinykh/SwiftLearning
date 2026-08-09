import SwiftUI

@main
struct SwiftLearningApp: App {
    @StateObject private var progressStore = LearningProgressStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(progressStore)
        }
    }
}
