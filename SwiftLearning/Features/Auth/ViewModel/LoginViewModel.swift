import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Private properties -

    private let session: SessionState
    private let output: (AuthOutput) -> Void

    // MARK: - Public properties -

    @Published var email = ""
    @Published var password = ""
    @Published private(set) var state: AuthFormState = .idle

    var buttonTitle: String {
        state.isLoading ? L10n.string("auth.login.signingIn") : L10n.string("auth.login.title")
    }

    // MARK: - Init -

    init(
        session: SessionState,
        output: @escaping (AuthOutput) -> Void
    ) {
        self.session = session
        self.output = output
    }

    // MARK: - Public methods -

    func login() async {
        guard !state.isLoading else { return }

        state = .loading

        do {
            try await session.login(email: email, password: password)
            state = .idle
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func openRegistration() {
        output(.openRegistration)
    }
}
