final class AppDependencies {
    // MARK: - Public properties -

    let services: AppServices
    let session: SessionState

    // MARK: - Init -

    init(
        services: AppServices,
        session: SessionState
    ) {
        self.services = services
        self.session = session
    }
}

final class AppServices {
    // MARK: - Public properties -

    let lessonsService: LessonsServicing
    let userService: UserServicing
    let practiceService: PracticeServicing
    let authService: AuthServicing

    // MARK: - Init -

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
