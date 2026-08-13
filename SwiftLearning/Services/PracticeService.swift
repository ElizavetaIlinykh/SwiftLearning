import Foundation

private struct PracticeCompletionRequest: Encodable {
    let correctAnswersCount: Int
    let totalAnswersCount: Int
}

protocol PracticeServicing {
    func fetchTopics() async throws -> [PracticeCategory]
    func fetchTasks(topicID: String) async throws -> [PracticeTask]
    func completeTopic(
        topicID: String,
        correctAnswersCount: Int,
        totalAnswersCount: Int
    ) async throws -> PracticeProgress
    func fetchPracticeProgress() async throws -> [PracticeProgress]
}

final class PracticeService: PracticeServicing {
    private let networkManager: NetworkManaging
    private let userID: String

    init(
        networkManager: NetworkManaging,
        userID: String = "993ba076-6998-4a3a-b3da-55fd517f704d"
    ) {
        self.networkManager = networkManager
        self.userID = userID
    }

    func fetchTopics() async throws -> [PracticeCategory] {
        try await networkManager.get("/practice/topics")
    }

    func fetchTasks(topicID: String) async throws -> [PracticeTask] {
        try await networkManager.get("/practice/topics/\(topicID)/tasks")
    }

    func completeTopic(
        topicID: String,
        correctAnswersCount: Int,
        totalAnswersCount: Int
    ) async throws -> PracticeProgress {
        try await networkManager.post(
            "/practice/topics/\(topicID)/complete",
            body: PracticeCompletionRequest(
                correctAnswersCount: correctAnswersCount,
                totalAnswersCount: totalAnswersCount
            ),
            queryItems: [URLQueryItem(name: "user_id", value: userID)]
        )
    }

    func fetchPracticeProgress() async throws -> [PracticeProgress] {
        try await networkManager.get("/users/\(userID)/practice-progress")
    }
}
