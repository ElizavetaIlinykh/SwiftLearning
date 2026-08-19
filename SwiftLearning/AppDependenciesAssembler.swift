@MainActor
enum AppDependenciesAssembler {
    static func assemble() -> AppDependencies {
        let tokenStorage = KeychainTokenStorage()
        let networkManager = NetworkManager(tokenStorage: tokenStorage)
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
            session: session
        )
    }
}
