import Foundation

protocol UserServicing {
    func fetchUser() async throws -> UserProfile
    func fetchStatistics() async throws -> UserStatistics
}

final class UserService: UserServicing {
    private let networkManager: NetworkManaging
    private let userID: String

    init(
        networkManager: NetworkManaging,
        userID: String = "993ba076-6998-4a3a-b3da-55fd517f704d"
    ) {
        self.networkManager = networkManager
        self.userID = userID
    }

    func fetchUser() async throws -> UserProfile {
        try await networkManager.get("/users/\(userID)")
    }

    func fetchStatistics() async throws -> UserStatistics {
        try await networkManager.get("/users/\(userID)/statistics")
    }
}
