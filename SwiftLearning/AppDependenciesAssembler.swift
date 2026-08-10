enum AppDependenciesAssembler {
    static func assemble() -> AppDependencies {
        let networkManager = NetworkManager()
        let services = AppServices(networkManager: networkManager)

        return AppDependencies(
            networkManager: networkManager,
            services: services
        )
    }
}
