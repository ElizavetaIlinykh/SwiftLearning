struct AuthResponse: Decodable {
    // MARK: - Public properties -

    let accessToken: String
    let tokenType: String
    let user: UserProfile
}
