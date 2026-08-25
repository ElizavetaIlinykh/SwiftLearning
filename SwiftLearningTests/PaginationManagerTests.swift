import Foundation
@testable import SwiftLearning
import Testing

@Suite("Pagination managers")
@MainActor
struct PaginationManagerTests {
    @Test
    func lessonsManagerFetchCachesFirstPage() async throws {
        let service = LessonsServiceMock(
            lessonPages: [
                [
                    lesson(id: "one", order: 1),
                    lesson(id: "two", order: 2)
                ]
            ]
        )
        let manager = LessonsManager(lessonsService: service)

        let firstFetch = try await manager.fetch()
        let secondFetch = try await manager.fetch()

        #expect(firstFetch.map(\.id) == ["one", "two"])
        #expect(secondFetch.map(\.id) == ["one", "two"])
        #expect(service.fetchLessonsCalls == 1)
    }

    @Test
    func lessonsManagerLoadMoreAppendsNextPage() async throws {
        let firstPage = (1 ... 20).map { lesson(id: "lesson-\($0)", order: $0) }
        let service = LessonsServiceMock(
            lessonPages: [
                firstPage,
                [lesson(id: "lesson-21", order: 21)]
            ]
        )
        let manager = LessonsManager(lessonsService: service)

        _ = try await manager.fetch()
        let loadedLessons = try await manager.loadMore()

        #expect(loadedLessons.count == 21)
        #expect(loadedLessons.last?.id == "lesson-21")
        #expect(service.fetchLessonsCalls == 2)
    }

    @Test
    func practiceTasksManagerCompletesTopicThroughService() async throws {
        let service = PracticeServiceMock()
        let manager = PracticeTasksManager(
            topicID: "topic",
            practiceService: service
        )

        let progress = try await manager.completeTopic(
            correctAnswersCount: 3,
            totalAnswersCount: 4
        )

        #expect(progress.topicId == "topic")
        #expect(progress.correctAnswersCount == 3)
        #expect(progress.totalAnswersCount == 4)
        #expect(service.completionRequest?.topicID == "topic")
        #expect(service.completionRequest?.correctAnswersCount == 3)
        #expect(service.completionRequest?.totalAnswersCount == 4)
    }
}

private func lesson(
    id: String,
    order: Int,
    status: LessonStatus = .available
) -> LessonSummary {
    LessonSummary(
        id: id,
        title: "Lesson \(order)",
        description: "Description \(order)",
        order: order,
        status: status
    )
}

@MainActor
private final class LessonsServiceMock: LessonsServicing {
    private let lessonPages: [[LessonSummary]]
    private(set) var fetchLessonsCalls = 0

    init(lessonPages: [[LessonSummary]]) {
        self.lessonPages = lessonPages
    }

    func fetchLessons(offset: Int, limit: Int) async throws -> PaginatedResponse<LessonSummary> {
        let pageIndex = fetchLessonsCalls
        fetchLessonsCalls += 1
        let items = pageIndex < lessonPages.count ? lessonPages[pageIndex] : []

        return PaginatedResponse(
            items: items,
            total: lessonPages.flatMap(\.self).count,
            limit: limit,
            offset: offset,
            hasMore: items.count >= limit
        )
    }

    func fetchLesson(id _: String) async throws -> LessonDetails {
        throw TestError.unimplemented
    }

    func fetchLessonQuestions(lessonID _: String) async throws -> [LessonQuizQuestion] {
        throw TestError.unimplemented
    }

    func fetchLessonCodeTask(lessonID _: String) async throws -> LessonCodeTask {
        throw TestError.unimplemented
    }

    func completeLesson(id _: String) async throws -> LessonProgress {
        throw TestError.unimplemented
    }
}

@MainActor
private final class PracticeServiceMock: PracticeServicing {
    private(set) var completionRequest: CompletionRequest?

    func fetchTopics(offset _: Int, limit _: Int) async throws -> PaginatedResponse<PracticeCategory> {
        throw TestError.unimplemented
    }

    func fetchTasks(topicID _: String, offset _: Int, limit _: Int) async throws -> PaginatedResponse<PracticeTask> {
        throw TestError.unimplemented
    }

    func completeTopic(
        topicID: String,
        correctAnswersCount: Int,
        totalAnswersCount: Int
    ) async throws -> PracticeProgress {
        completionRequest = CompletionRequest(
            topicID: topicID,
            correctAnswersCount: correctAnswersCount,
            totalAnswersCount: totalAnswersCount
        )

        return PracticeProgress(
            topicId: topicID,
            correctAnswersCount: correctAnswersCount,
            totalAnswersCount: totalAnswersCount,
            scorePercent: 75,
            completedAt: Date(timeIntervalSince1970: 0)
        )
    }

    func fetchPracticeProgress() async throws -> [PracticeProgress] {
        throw TestError.unimplemented
    }

    struct CompletionRequest: Equatable {
        let topicID: String
        let correctAnswersCount: Int
        let totalAnswersCount: Int
    }
}

private enum TestError: Error {
    case unimplemented
}
