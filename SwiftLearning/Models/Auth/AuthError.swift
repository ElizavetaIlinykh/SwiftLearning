import Foundation

enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case emailAlreadyUsed
    case invalidInput
    case unauthorized
    case missingSession
    case requestFailed(String)

    // MARK: - Public properties -

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            L10n.string("auth.error.invalidCredentials")
        case .emailAlreadyUsed:
            L10n.string("auth.error.emailAlreadyUsed")
        case .invalidInput:
            L10n.string("auth.error.invalidInput")
        case .unauthorized, .missingSession:
            L10n.string("auth.error.unauthorized")
        case let .requestFailed(message):
            message
        }
    }
}
