import Combine
import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    // MARK: - Private properties -

    private let session: SessionState
    private let output: (AuthOutput) -> Void

    // MARK: - Public properties -

    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var state: AuthFormState = .idle

    var buttonTitle: String {
        state.isLoading ? "Creating..." : "Register"
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

    func register() async {
        guard !state.isLoading else { return }

        state = .loading

        do {
            try await session.register(
                name: name,
                email: email,
                password: password
            )
            state = .idle
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func openLogin() {
        output(.openLogin)
    }
}
