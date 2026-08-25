import SwiftUI

struct AuthCoordinatorView: View {
    // MARK: - Public properties -

    let dependencies: AppDependencies

    // MARK: - Private properties -

    @State private var router = AuthRouter()

    // MARK: - Public properties -

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            loginView
                .navigationDestination(for: AuthRouter.Route.self) { route in
                    destination(for: route)
                }
        }
        .environment(router)
    }

    private var loginView: some View {
        AuthModuleAssembler.assembleLogin(
            dependencies: dependencies,
            output: handleOutput
        )
    }

    // MARK: - Private methods -

    private func handleOutput(_ output: AuthOutput) {
        switch output {
        case .openRegistration:
            router.navigate(to: .registration)
        case .openLogin:
            router.popToRoot()
        }
    }

    @ViewBuilder
    private func destination(for route: AuthRouter.Route) -> some View {
        switch route {
        case .registration:
            AuthModuleAssembler.assembleRegister(
                dependencies: dependencies,
                output: handleOutput
            )
        }
    }
}

#Preview {
    AuthCoordinatorView(dependencies: AppDependenciesAssembler.assemble())
}
