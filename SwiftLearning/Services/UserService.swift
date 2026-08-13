import Foundation

protocol UserServicing {
    func fetchUser() async throws -> UserProfile
    func fetchStatistics() async throws -> UserStatistics
}

final class UserService: UserServicing {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func fetchUser() async throws -> UserProfile {
        try await networkManager.get("/me")
    }

    func fetchStatistics() async throws -> UserStatistics {
        try await networkManager.get("/me/statistics")
    }
}
