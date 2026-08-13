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
            return "Incorrect email or password."
        case .emailAlreadyUsed:
            return "This email is already registered."
        case .invalidInput:
            return "Please check the entered data."
        case .unauthorized, .missingSession:
            return "Please sign in to continue."
        case .requestFailed(let message):
            return message
        }
    }
}
