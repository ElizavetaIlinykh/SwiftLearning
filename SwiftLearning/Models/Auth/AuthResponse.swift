struct AuthResponse: Decodable {
    // MARK: - Public properties -

    let accessToken: String
    let tokenType: String
    let user: UserProfile

    // MARK: - Init -

    init(accessToken: String, tokenType: String = "bearer", user: UserProfile) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.user = user
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType) ?? "bearer"
        user = try container.decode(UserProfile.self, forKey: .user)
    }

    private enum CodingKeys: String, CodingKey {
        case accessToken
        case tokenType
        case user
    }
}
