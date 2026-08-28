import SwiftUI

struct MainCoordinatorView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    var body: some View {
        MainTabView(dependencies: dependencies)
    }
}

#Preview {
    let dependencies = AppDependenciesAssembler.assemble()

    MainCoordinatorView(dependencies: dependencies)
        .environment(dependencies.languageSettings)
}
