import Foundation

private struct EmptyRequestBody: Encodable {}

enum LessonCodeTaskError: LocalizedError {
    case notFound

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "No code task is available for this lesson."
        }
    }
}

protocol LessonsServicing {
    func fetchLessons(offset: Int, limit: Int) async throws -> PaginatedResponse<LessonSummary>
    func fetchLesson(id: String) async throws -> LessonDetails
    func fetchLessonQuestions(lessonID: String) async throws -> [LessonQuizQuestion]
    func fetchLessonCodeTask(lessonID: String) async throws -> LessonCodeTask
    func completeLesson(id: String) async throws -> LessonProgress
}

final class LessonsService: LessonsServicing {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchLessons(offset: Int, limit: Int) async throws -> PaginatedResponse<LessonSummary> {
        try await networkManager.get(
            "/me/lessons",
            queryItems: paginationQueryItems(offset: offset, limit: limit)
        )
    }

    func fetchLesson(id: String) async throws -> LessonDetails {
        try await networkManager.get("/lessons/\(id)")
    }

    func fetchLessonQuestions(lessonID: String) async throws -> [LessonQuizQuestion] {
        try await networkManager.get("/lessons/\(lessonID)/questions")
    }

    func fetchLessonCodeTask(lessonID: String) async throws -> LessonCodeTask {
        do {
            return try await networkManager.get("/lessons/\(lessonID)/code-task")
        } catch NetworkManager.NetworkError.serverError(let statusCode, _) where statusCode == 404 {
            throw LessonCodeTaskError.notFound
        }
    }

    func completeLesson(id: String) async throws -> LessonProgress {
        try await networkManager.post(
            "/lessons/\(id)/complete",
            body: EmptyRequestBody()
        )
    }
}
