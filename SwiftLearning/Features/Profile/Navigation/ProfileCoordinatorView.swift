import SwiftUI

struct ProfileCoordinatorView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    // MARK: - Private properties -

    @State private var router = ProfileRouter()

    // MARK: - Public properties -

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            ProfileModuleAssembler.assemble(dependencies: dependencies)
                .navigationDestination(for: ProfileRouter.Route.self) { route in
                    destination(for: route)
                }
        }
        .environment(router)
    }

    // MARK: - Private methods -

    @ViewBuilder
    private func destination(for route: ProfileRouter.Route) -> some View {
        switch route {
        case .statistics:
            RoutePlaceholderView(title: L10n.string("profile.placeholder.statistics"))
        case .settings:
            ProfileSettingsView()
        }
    }
}

#Preview {
    ProfileCoordinatorView(dependencies: AppDependenciesAssembler.assemble())
        .environment(LanguageSettings())
}
