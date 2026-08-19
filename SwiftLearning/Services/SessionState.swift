import Combine
import Foundation

enum AuthStatus: Equatable {
    case unknown
    case authenticated
    case unauthenticated
}

@MainActor
final class SessionState: ObservableObject {
    // MARK: - Private properties -

    @Published private(set) var status: AuthStatus = .unknown
    @Published private(set) var currentUser: UserProfile?
    private let authService: AuthServicing

    // MARK: - Init -

    init(authService: AuthServicing) {
        self.authService = authService
    }

    // MARK: - Public methods -

    func restoreSession() async {
        guard status == .unknown else { return }

        guard authService.hasStoredAccessToken() else {
            status = .unauthenticated
            currentUser = nil
            return
        }

        do {
            currentUser = try await authService.fetchCurrentUser()
            status = .authenticated
        } catch AuthError.unauthorized {
            logout()
        } catch {
            status = .unauthenticated
            currentUser = nil
        }
    }

    func login(email: String, password: String) async throws {
        currentUser = try await authService.login(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        )
        status = .authenticated
    }

    func register(name: String, email: String, password: String) async throws {
        currentUser = try await authService.register(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        )
        status = .authenticated
    }

    func logout() {
        authService.logout()
        currentUser = nil
        status = .unauthenticated
    }

    func handleUnauthorized() {
        guard status == .authenticated || status == .unknown else { return }
        logout()
    }
}
