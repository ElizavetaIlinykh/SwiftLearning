final class AppDependencies {
    let networkManager: NetworkManaging
    let services: AppServices
    let session: SessionState

    init(
        networkManager: NetworkManaging = NetworkManager(),
        services: AppServices,
        session: SessionState
    ) {
        self.networkManager = networkManager
        self.services = services
        self.session = session
    }
}

final class AppServices {
    let lessonsService: LessonsServicing
    let userService: UserServicing
    let practiceService: PracticeServicing
    let authService: AuthServicing

    init(
        networkManager: NetworkManaging,
        authService: AuthServicing
    ) {
        lessonsService = LessonsService(networkManager: networkManager)
        userService = UserService(networkManager: networkManager)
        practiceService = PracticeService(networkManager: networkManager)
        self.authService = authService
    }

    init(
        lessonsService: LessonsServicing,
        userService: UserServicing,
        practiceService: PracticeServicing,
        authService: AuthServicing
    ) {
        self.lessonsService = lessonsService
        self.userService = userService
        self.practiceService = practiceService
        self.authService = authService
    }
}
