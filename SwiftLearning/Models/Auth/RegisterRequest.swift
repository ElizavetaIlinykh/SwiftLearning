struct RegisterRequest: Encodable {
    // MARK: - Public properties -

    let email: String
    let name: String
    let password: String
}
