import Foundation

protocol LessonsServicing {
    func fetchLessons() async throws -> [LessonSummary]
    func fetchLesson(id: String) async throws -> LessonDetails
}

final class LessonsService: LessonsServicing {
    private let networkManager: NetworkManaging
    private let userID: String

    init(
        networkManager: NetworkManaging = NetworkManager(),
        userID: String = "993ba076-6998-4a3a-b3da-55fd517f704d"
    ) {
        self.networkManager = networkManager
        self.userID = userID
    }

    func fetchLessons() async throws -> [LessonSummary] {
        try await networkManager.get("/users/\(userID)/lessons")
    }

    func fetchLesson(id: String) async throws -> LessonDetails {
        try await networkManager.get("/lessons/\(id)")
    }
}
