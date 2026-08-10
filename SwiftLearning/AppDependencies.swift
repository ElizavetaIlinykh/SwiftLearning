final class AppDependencies {
    let networkManager: NetworkManaging
    let services: AppServices

    init(
        networkManager: NetworkManaging = NetworkManager(),
        services: AppServices
    ) {
        self.networkManager = networkManager
        self.services = services
    }
}

final class AppServices {
    let lessonsService: LessonsServicing

    init(networkManager: NetworkManaging) {
        self.lessonsService = LessonsService(networkManager: networkManager)
    }

    init(lessonsService: LessonsServicing) {
        self.lessonsService = lessonsService
    }
}
