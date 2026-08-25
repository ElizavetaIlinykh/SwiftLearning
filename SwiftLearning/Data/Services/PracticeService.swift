import Foundation

private struct PracticeCompletionRequest: Encodable {
    // MARK: - Public properties -

    let correctAnswersCount: Int
    let totalAnswersCount: Int
}

protocol PracticeServicing {
    func fetchTopics(offset: Int, limit: Int) async throws -> PaginatedResponse<PracticeCategory>
    func fetchTasks(topicID: String, offset: Int, limit: Int) async throws -> PaginatedResponse<PracticeTask>
    func completeTopic(
        topicID: String,
        correctAnswersCount: Int,
        totalAnswersCount: Int
    ) async throws -> PracticeProgress
    func fetchPracticeProgress() async throws -> [PracticeProgress]
}

final class PracticeService: PracticeServicing {
    // MARK: - Private properties -

    private let networkManager: NetworkManaging

    // MARK: - Init -

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    // MARK: - Public methods -

    func fetchTopics(offset: Int, limit: Int) async throws -> PaginatedResponse<PracticeCategory> {
        try await networkManager.get(
            "/practice/topics",
            queryItems: paginationQueryItems(offset: offset, limit: limit)
        )
    }

    func fetchTasks(topicID: String, offset: Int, limit: Int) async throws -> PaginatedResponse<PracticeTask> {
        try await networkManager.get(
            "/practice/topics/\(topicID)/tasks",
            queryItems: paginationQueryItems(offset: offset, limit: limit)
        )
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
