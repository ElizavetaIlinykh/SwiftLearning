import Foundation

struct AuthRequest: Encodable {
    let email: String
    let password: String
}

struct RegisterRequest: Encodable {
    let email: String
    let name: String
    let password: String
}

struct AuthResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let user: UserProfile
}

enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case emailAlreadyUsed
    case invalidInput
    case unauthorized
    case missingSession
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            "Incorrect email or password."
        case .emailAlreadyUsed:
            "This email is already registered."
        case .invalidInput:
            "Please check the entered data."
        case .unauthorized, .missingSession:
            "Please sign in to continue."
        case let .requestFailed(message):
            message
        }
    }
}
