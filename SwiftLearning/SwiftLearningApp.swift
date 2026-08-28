import SwiftUI

@main
struct SwiftLearningApp: App {
    // MARK: - Private properties -

    private let dependencies = AppDependenciesAssembler.assemble()

    // MARK: - Public properties -

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(dependencies: dependencies)
                .environment(dependencies.languageSettings)
                .environment(\.locale, Locale(identifier: dependencies.languageSettings.selectedLanguage.rawValue))
        }
    }
}
