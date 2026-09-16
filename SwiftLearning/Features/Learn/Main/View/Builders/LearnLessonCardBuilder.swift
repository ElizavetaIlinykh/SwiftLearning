import Foundation

struct LearnLessonCardBuilder {
    // MARK: - Public methods -

    func build(lessons: [LessonSummary]) -> [LessonCardViewData] {
        lessons.map(build(lesson:))
    }

    // MARK: - Private methods -

    private func build(lesson: LessonSummary) -> LessonCardViewData {
        LessonCardViewData(
            id: lesson.id,
            title: lesson.title,
            description: lesson.description ?? "",
            order: lesson.order,
            state: state(for: lesson.status),
            actionTitle: actionTitle(for: lesson)
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

    private func actionTitle(for lesson: LessonSummary) -> String {
        lesson.order == 1 ? L10n.string("learn.lesson.start") : L10n.string("learn.lesson.continue")
    }
}
