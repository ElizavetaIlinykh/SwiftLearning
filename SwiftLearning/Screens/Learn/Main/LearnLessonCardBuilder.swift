import Foundation

struct LearnLessonCardBuilder {
    // MARK: - Public methods -

    func build(lessons: [LessonSummary]) -> [LessonCardViewModel] {
        lessons.map(build(lesson:))
    }

    // MARK: - Private methods -

    private func build(lesson: LessonSummary) -> LessonCardViewModel {
        LessonCardViewModel(
            id: lesson.id,
            title: lesson.title,
            description: lesson.description,
            order: lesson.order,
            state: state(for: lesson.status)
        )
    }

    private func state(for status: LessonStatus) -> LessonState {
        switch status {
        case .completed:
            .completed
        case .available:
            .current
        case .locked:
            .locked
        }
    }
}
