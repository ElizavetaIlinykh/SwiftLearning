import Foundation

protocol PracticeServicing {
    func fetchTopics() async throws -> [PracticeCategory]
    func fetchTasks(topicID: String) async throws -> [PracticeTask]
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
}
