import Foundation
@testable import SwiftLearning
import Testing

@Suite("LessonQuizViewModel")
@MainActor
struct LessonQuizViewModelTests {
    @Test
    func selectingCorrectAnswerHidesIncorrectAnswers() async {
        let viewModel = makeViewModel()

        await viewModel.loadQuestions()
        viewModel.selectAnswer(at: 1)

        guard case let .content(content) = viewModel.state else {
            Issue.record("Expected content state")
            return
        }

        #expect(content.question.answers.map(\.text) == ["Correct"])
        #expect(content.question.answers.map(\.state) == [.selectedCorrect])
    }

    @Test
    func selectingIncorrectAnswerShowsSelectedAndCorrectAnswers() async {
        let viewModel = makeViewModel()

        await viewModel.loadQuestions()
        viewModel.selectAnswer(at: 2)

        guard case let .content(content) = viewModel.state else {
            Issue.record("Expected content state")
            return
        }

        #expect(content.question.answers.map(\.text) == ["Correct", "Chosen wrong"])
        #expect(content.question.answers.map(\.state) == [.correct, .selectedIncorrect])
    }
}

@MainActor
private func makeViewModel() -> LessonQuizViewModel {
    LessonQuizViewModel(
        lessonID: "lesson",
        quizManager: LessonQuizManager(
            lessonID: "lesson",
            lessonsService: LessonQuizLessonsServiceMock()
        ),
        contentBuilder: LessonQuizContentBuilder(),
        output: { _ in }
    )
}

@MainActor
private final class LessonQuizLessonsServiceMock: LessonsServicing {
    func fetchLessons(offset: Int, limit: Int) async throws -> PaginatedResponse<LessonSummary> {
        PaginatedResponse(
            items: [],
            total: 0,
            limit: limit,
            offset: offset,
            hasMore: false
        )
    }

    func fetchLesson(id _: String) async throws -> LessonDetails {
        throw LessonQuizViewModelTestError.unimplemented
    }

    func fetchLessonQuestions(lessonID _: String) async throws -> [LessonQuizQuestion] {
        [
            LessonQuizQuestion(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                text: "Question",
                order: 1,
                explanation: "Explanation",
                difficulty: .easy,
                tags: [],
                answers: [
                    LessonQuizAnswer(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000101")!,
                        text: "Hidden wrong",
                        order: 1,
                        isCorrect: false
                    ),
                    LessonQuizAnswer(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000102")!,
                        text: "Correct",
                        order: 2,
                        isCorrect: true
                    ),
                    LessonQuizAnswer(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000103")!,
                        text: "Chosen wrong",
                        order: 3,
                        isCorrect: false
                    )
                ]
            )
        ]
    }

    func fetchLessonCodeTask(lessonID _: String) async throws -> LessonCodeTask {
        throw LessonQuizViewModelTestError.unimplemented
    }

    func completeLesson(id _: String) async throws -> LessonProgress {
        throw LessonQuizViewModelTestError.unimplemented
    }
}

private enum LessonQuizViewModelTestError: Error {
    case unimplemented
}
