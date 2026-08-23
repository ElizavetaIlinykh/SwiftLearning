import SwiftUI

@main
struct SwiftLearningApp: App {
    // MARK: - Private properties -

    private let dependencies = AppDependenciesAssembler.assemble()

    // MARK: - Public properties -

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(dependencies: dependencies)
        }
    }
}
