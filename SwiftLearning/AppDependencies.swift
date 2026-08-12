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
    let userService: UserServicing

    init(networkManager: NetworkManaging) {
        self.lessonsService = LessonsService(networkManager: networkManager)
        self.userService = UserService(networkManager: networkManager)
    }

    init(
        lessonsService: LessonsServicing,
        userService: UserServicing
    ) {
        self.lessonsService = lessonsService
        self.userService = userService
    }
}
