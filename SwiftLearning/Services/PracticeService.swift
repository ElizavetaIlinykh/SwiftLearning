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

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
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
            )
        )
    }

    func fetchPracticeProgress() async throws -> [PracticeProgress] {
        try await networkManager.get("/me/practice-progress")
    }
}
