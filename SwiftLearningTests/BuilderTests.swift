@testable import SwiftLearning
import Testing

@Suite("Builders")
struct BuilderTests {
    @Test
    func lessonCardBuilderMapsLessonsToCardViewModels() {
        L10n.setLanguage(.english)

        let lessons = [
            LessonSummary(
                id: "lesson-1",
                title: "Completed",
                description: "Done",
                order: 1,
                status: .completed
            ),
            LessonSummary(
                id: "lesson-2",
                title: "Available",
                description: "Current",
                order: 2,
                status: .available
            ),
            LessonSummary(
                id: "lesson-3",
                title: "Locked",
                description: "Later",
                order: 3,
                status: .locked
            )
        ]

        let cards = LearnLessonCardBuilder().build(lessons: lessons)

        #expect(cards.map(\.id) == ["lesson-1", "lesson-2", "lesson-3"])
        #expect(cards.map(\.state) == [.completed, .current, .locked])
        #expect(cards.map(\.actionTitle) == ["Start", "Continue", "Continue"])
    }

    @Test
    func progressCardBuilderCalculatesProgressState() {
        L10n.setLanguage(.english)

        let lessons = [
            LessonSummary(
                id: "lesson-1",
                title: "One",
                description: "First",
                order: 1,
                status: .completed
            ),
            LessonSummary(
                id: "lesson-2",
                title: "Two",
                description: "Second",
                order: 2,
                status: .available
            )
        ]

        let viewModel = LearnProgressCardBuilder(courseTitle: "Course").build(lessons: lessons)

        #expect(viewModel.courseTitle == "Course")
        #expect(viewModel.completedLessonsTitle == "1 of 2 lessons completed")
        #expect(viewModel.completedLessonsCount == 1)
        #expect(viewModel.totalLessonsCount == 2)
        #expect(viewModel.progress == 0.5)
        #expect(viewModel.state == .inProgress)
    }
}
