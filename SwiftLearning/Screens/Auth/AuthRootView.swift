import SwiftUI

struct AuthRootView: View {
    @ObservedObject var session: SessionState
    @State private var route: AuthRoute = .login

    var body: some View {
        NavigationStack {
            switch route {
            case .login:
                LoginView(
                    session: session,
                    onRegisterTapped: { route = .register }
                )
            case .register:
                RegisterView(
                    session: session,
                    onLoginTapped: { route = .login }
                )
            }
        }
    }
}

private enum AuthRoute {
    case login
    case register
}

#Preview {
    AuthRootView(session: AppDependenciesAssembler.assemble().session)
}
