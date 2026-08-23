import SwiftUI

struct MainCoordinatorView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    var body: some View {
        MainTabView(dependencies: dependencies)
    }
}

#Preview {
    MainCoordinatorView(dependencies: AppDependenciesAssembler.assemble())
}
