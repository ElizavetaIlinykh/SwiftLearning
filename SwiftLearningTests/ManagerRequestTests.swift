import Foundation
@testable import SwiftLearning
import Testing

@Suite("Manager request handling")
@MainActor
struct ManagerRequestTests {
    @Test
    func lessonDetailsManagerSharesInFlightRequest() async throws {
        let service = LessonDetailsServiceMock(
            lesson: LessonDetails(
                id: "lesson",
                title: "Lesson",
                description: "Description",
                order: 1,
                theory: "Theory",
                codeExample: "print(\"Hello\")"
            )
        )
        let manager = LessonDetailsManager(
            lessonID: "lesson",
            lessonsService: service
        )

        async let firstResult = manager.loadLesson()
        async let secondResult = manager.loadLesson()
        let lessons = try await [firstResult, secondResult]

        #expect(lessons.map(\.id) == ["lesson", "lesson"])
        #expect(service.fetchLessonCalls == 1)
    }
}

@MainActor
private final class LessonDetailsServiceMock: LessonsServicing {
    private let lesson: LessonDetails
    private(set) var fetchLessonCalls = 0

    init(lesson: LessonDetails) {
        self.lesson = lesson
    }

    func fetchLessons(offset _: Int, limit _: Int) async throws -> PaginatedResponse<LessonSummary> {
        throw ManagerRequestTestError.unimplemented
    }

    func fetchLesson(id _: String) async throws -> LessonDetails {
        fetchLessonCalls += 1
        try await Task.sleep(nanoseconds: 50_000_000)
        return lesson
    }

    func fetchLessonQuestions(lessonID _: String) async throws -> [LessonQuizQuestion] {
        throw ManagerRequestTestError.unimplemented
    }

    func fetchLessonCodeTask(lessonID _: String) async throws -> LessonCodeTask {
        throw ManagerRequestTestError.unimplemented
    }

    func completeLesson(id _: String) async throws -> LessonProgress {
        throw ManagerRequestTestError.unimplemented
    }
}

private enum ManagerRequestTestError: Error {
    case unimplemented
}
