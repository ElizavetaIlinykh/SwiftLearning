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
        LoginView(
            session: dependencies.session,
            output: { output in
                switch output {
                case .openRegistration:
                    router.navigate(to: .registration)
                case .openLogin:
                    router.popToRoot()
                }
            }
        )
    }

    // MARK: - Private methods -

    @ViewBuilder
    private func destination(for route: AuthRouter.Route) -> some View {
        switch route {
        case .registration:
            RegisterView(
                session: dependencies.session,
                output: { output in
                    switch output {
                    case .openRegistration:
                        router.navigate(to: .registration)
                    case .openLogin:
                        router.popToRoot()
                    }
                }
            )
        }
    }
}

#Preview {
    AuthCoordinatorView(dependencies: AppDependenciesAssembler.assemble())
}
