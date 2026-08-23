import Foundation

struct AuthRequest: Encodable {
    // MARK: - Public properties -

    let email: String
    let password: String
}
