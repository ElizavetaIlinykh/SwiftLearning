import Foundation

protocol UserServicing {
    func fetchUser() async throws -> UserProfile
    func fetchStatistics() async throws -> UserStatistics
}

final class UserService: UserServicing {
    // MARK: - Private properties -

    private let networkManager: NetworkManaging

    // MARK: - Init -

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    // MARK: - Public methods -

    func fetchUser() async throws -> UserProfile {
        try await networkManager.get(.currentUser)
    }

    func fetchStatistics() async throws -> UserStatistics {
        try await networkManager.get(.userStatistics)
    }
}
