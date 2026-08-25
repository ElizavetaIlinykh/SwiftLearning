@testable import SwiftLearning
import Testing

@Suite("LearnViewModel")
@MainActor
struct LearnViewModelTests {
    @Test
    func fetchLessonsBuildsSortedContentState() async {
        let service = LearnViewModelLessonsServiceMock(
            lessons: [
                lessonSummary(id: "second", order: 2, status: .available),
                lessonSummary(id: "first", order: 1, status: .completed)
            ]
        )
        let viewModel = LearnViewModel(
            lessonsManager: LessonsManager(lessonsService: service),
            lessonCardBuilder: LearnLessonCardBuilder(),
            progressCardBuilder: LearnProgressCardBuilder(),
            output: { _ in }
        )

        await viewModel.fetchLessons()

        guard case let .content(content) = viewModel.state else {
            Issue.record("Expected content state")
            return
        }

        #expect(content.lessonCards.map(\.id) == ["first", "second"])
        #expect(content.progressCard.completedLessonsCount == 1)
        #expect(content.progressCard.totalLessonsCount == 2)
    }

    @Test
    func selectLessonEmitsOpenLessonOutput() async {
        var receivedOutput: LearnOutput?
        let service = LearnViewModelLessonsServiceMock(
            lessons: [
                lessonSummary(id: "lesson", order: 1, status: .available)
            ]
        )
        let viewModel = LearnViewModel(
            lessonsManager: LessonsManager(lessonsService: service),
            lessonCardBuilder: LearnLessonCardBuilder(),
            progressCardBuilder: LearnProgressCardBuilder(),
            output: { receivedOutput = $0 }
        )

        await viewModel.fetchLessons()
        viewModel.selectLesson(id: "lesson")

        guard case let .openLesson(id, lessonsCount) = receivedOutput else {
            Issue.record("Expected openLesson output")
            return
        }

        #expect(id == "lesson")
        #expect(lessonsCount == 1)
    }
}

private func lessonSummary(
    id: String,
    order: Int,
    status: LessonStatus
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
private final class LearnViewModelLessonsServiceMock: LessonsServicing {
    private let lessons: [LessonSummary]

    init(lessons: [LessonSummary]) {
        self.lessons = lessons
    }

    func fetchLessons(offset: Int, limit: Int) async throws -> PaginatedResponse<LessonSummary> {
        PaginatedResponse(
            items: lessons,
            total: lessons.count,
            limit: limit,
            offset: offset,
            hasMore: false
        )
    }

    func fetchLesson(id _: String) async throws -> LessonDetails {
        throw LearnViewModelTestError.unimplemented
    }

    func fetchLessonQuestions(lessonID _: String) async throws -> [LessonQuizQuestion] {
        throw LearnViewModelTestError.unimplemented
    }

    func fetchLessonCodeTask(lessonID _: String) async throws -> LessonCodeTask {
        throw LearnViewModelTestError.unimplemented
    }

    func completeLesson(id _: String) async throws -> LessonProgress {
        throw LearnViewModelTestError.unimplemented
    }
}

private enum LearnViewModelTestError: Error {
    case unimplemented
}
