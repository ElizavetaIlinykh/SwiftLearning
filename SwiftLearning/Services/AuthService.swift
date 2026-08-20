import Foundation

protocol AuthServicing {
    func register(name: String, email: String, password: String) async throws -> UserProfile
    func login(email: String, password: String) async throws -> UserProfile
    func fetchCurrentUser() async throws -> UserProfile
    func hasStoredAccessToken() -> Bool
    func logout()
}

final class AuthService: AuthServicing {
    // MARK: - Private properties -

    private let networkManager: NetworkManaging
    private let tokenStorage: TokenStoring

    // MARK: - Init -

    init(
        networkManager: NetworkManaging,
        tokenStorage: TokenStoring
    ) {
        self.networkManager = networkManager
        self.tokenStorage = tokenStorage
    }

    // MARK: - Public methods -

    func register(name: String, email: String, password: String) async throws -> UserProfile {
        do {
            let response: AuthResponse = try await networkManager.post(
                "/auth/register",
                body: RegisterRequest(email: email, name: name, password: password)
            )
            try tokenStorage.saveAccessToken(response.accessToken)
            return response.user
        } catch {
            throw mapAuthError(error, isRegister: true)
        }
    }

    func login(email: String, password: String) async throws -> UserProfile {
        do {
            let response: AuthResponse = try await networkManager.post(
                "/auth/login",
                body: AuthRequest(email: email, password: password)
            )
            try tokenStorage.saveAccessToken(response.accessToken)
            return response.user
        } catch {
            throw mapAuthError(error, isRegister: false)
        }
    }

    func fetchCurrentUser() async throws -> UserProfile {
        do {
            return try await networkManager.get("/me")
        } catch let NetworkManager.NetworkError.serverError(statusCode, _) where statusCode == 401 {
            throw AuthError.unauthorized
        } catch {
            throw error
        }
    }

    func hasStoredAccessToken() -> Bool {
        (try? tokenStorage.fetchAccessToken()) != nil
    }

    func logout() {
        try? tokenStorage.deleteAccessToken()
    }

    // MARK: - Private methods -

    private func mapAuthError(_ error: Error, isRegister: Bool) -> AuthError {
        if let authError = error as? AuthError {
            return authError
        }

        if case let NetworkManager.NetworkError.serverError(statusCode, _) = error {
            switch statusCode {
            case 401:
                return isRegister ? .requestFailed("Could not register this account.") : .invalidCredentials
            case 409:
                return .emailAlreadyUsed
            case 422:
                return .invalidInput
            default:
                return .requestFailed("Request failed. Please try again.")
            }
        }

        return .requestFailed(UserFacingErrorMessage.message(for: error))
    }
}
