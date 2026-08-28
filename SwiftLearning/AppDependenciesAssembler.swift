@MainActor
enum AppDependenciesAssembler {
    // MARK: - Public methods -

    static func assemble() -> AppDependencies {
        let configuration = AppConfiguration.load()
        let languageSettings = LanguageSettings()
        let tokenStorage = KeychainTokenStorage()
        let networkManager = NetworkManager(
            baseURL: configuration.baseURL,
            tokenStorage: tokenStorage
        )
        let authService = AuthService(
            networkManager: networkManager,
            tokenStorage: tokenStorage
        )
        let session = SessionState(authService: authService)

        networkManager.unauthorizedHandler = { [weak session] in
            Task { @MainActor in
                session?.handleUnauthorized()
            }
        }

        let services = AppServices(
            networkManager: networkManager,
            authService: authService
        )

        return AppDependencies(
            services: services,
            session: session,
            languageSettings: languageSettings
        )
    }
}
