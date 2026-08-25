import Foundation
@testable import SwiftLearning
import Testing

@Suite("Auth and session flow")
@MainActor
struct AuthSessionTests {
    @Test
    func restoreSessionWithoutStoredTokenMarksUnauthenticated() async {
        let authService = AuthServiceMock(hasStoredAccessToken: false)
        let session = SessionState(authService: authService)

        await session.restoreSession()

        #expect(session.status == .unauthenticated)
        #expect(session.currentUser == nil)
        #expect(authService.fetchCurrentUserCalls == 0)
    }

    @Test
    func loginTrimsEmailAndAuthenticatesSession() async throws {
        let authService = AuthServiceMock(loginUser: user(id: "user"))
        let session = SessionState(authService: authService)

        try await session.login(email: " user@example.com ", password: "password")

        #expect(authService.loginRequest?.email == "user@example.com")
        #expect(authService.loginRequest?.password == "password")
        #expect(session.status == .authenticated)
        #expect(session.currentUser?.id == "user")
    }

    @Test
    func loginViewModelSetsFailedStateWhenLoginFails() async {
        let authService = AuthServiceMock(loginError: AuthError.invalidCredentials)
        let session = SessionState(authService: authService)
        let viewModel = LoginViewModel(session: session, output: { _ in })

        viewModel.email = "user@example.com"
        viewModel.password = "wrong"
        await viewModel.login()

        #expect(viewModel.state.errorMessage == AuthError.invalidCredentials.localizedDescription)
        #expect(session.status == .unknown)
    }

    @Test
    func loginViewModelEmitsOpenRegistration() {
        var receivedOutput: AuthOutput?
        let viewModel = LoginViewModel(
            session: SessionState(authService: AuthServiceMock()),
            output: { receivedOutput = $0 }
        )

        viewModel.openRegistration()

        guard case .openRegistration = receivedOutput else {
            Issue.record("Expected openRegistration output")
            return
        }
    }
}

private func user(id: String) -> UserProfile {
    UserProfile(
        id: id,
        email: "\(id)@example.com",
        name: "User \(id)",
        level: 1,
        completedLessonsCount: 0,
        createdAt: Date(timeIntervalSince1970: 0)
    )
}

@MainActor
private final class AuthServiceMock: AuthServicing {
    private let hasToken: Bool
    private let loginUser: UserProfile?
    private let loginError: Error?
    private(set) var fetchCurrentUserCalls = 0
    private(set) var loginRequest: LoginRequest?

    init(
        hasStoredAccessToken: Bool = true,
        loginUser: UserProfile? = nil,
        loginError: Error? = nil
    ) {
        hasToken = hasStoredAccessToken
        self.loginUser = loginUser
        self.loginError = loginError
    }

    func register(name _: String, email _: String, password _: String) async throws -> UserProfile {
        throw AuthSessionTestError.unimplemented
    }

    func login(email: String, password: String) async throws -> UserProfile {
        loginRequest = LoginRequest(email: email, password: password)

        if let loginError {
            throw loginError
        }

        return loginUser ?? user(id: "login")
    }

    func fetchCurrentUser() async throws -> UserProfile {
        fetchCurrentUserCalls += 1
        return user(id: "current")
    }

    func hasStoredAccessToken() -> Bool {
        hasToken
    }

    func logout() {}

    struct LoginRequest: Equatable {
        let email: String
        let password: String
    }
}

private enum AuthSessionTestError: Error {
    case unimplemented
}
