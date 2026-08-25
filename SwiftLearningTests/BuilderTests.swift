@testable import SwiftLearning
import Testing

@Suite("Builders")
struct BuilderTests {
    @Test
    func lessonCardBuilderMapsLessonsToCardViewModels() {
        let lessons = [
            LessonSummary(
                id: "completed",
                title: "Completed",
                description: "Done",
                order: 1,
                status: .completed
            ),
            LessonSummary(
                id: "available",
                title: "Available",
                description: "Current",
                order: 2,
                status: .available
            ),
            LessonSummary(
                id: "locked",
                title: "Locked",
                description: "Later",
                order: 3,
                status: .locked
            )
        ]

        let cards = LearnLessonCardBuilder().build(lessons: lessons)

        #expect(cards.map(\.id) == ["completed", "available", "locked"])
        #expect(cards.map(\.state) == [.completed, .current, .locked])
        #expect(cards.map(\.actionTitle) == ["Start", "Continue", "Continue"])
    }

    @Test
    func progressCardBuilderCalculatesProgressState() {
        let lessons = [
            LessonSummary(
                id: "one",
                title: "One",
                description: "First",
                order: 1,
                status: .completed
            ),
            LessonSummary(
                id: "two",
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
