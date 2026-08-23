import Foundation

struct LessonProgressBuilder {
    // MARK: - Public methods -

    func build(
        lesson: LessonDetails,
        totalLessonsCount: Int
    ) -> LessonProgressViewModel {
        LessonProgressViewModel(
            title: "Lesson \(lesson.order) of \(totalLessonsCount)",
            valueTitle: "\(lesson.order) / \(totalLessonsCount)",
            progress: progress(
                lessonOrder: lesson.order,
                totalLessonsCount: totalLessonsCount
            )
        )
    }

    // MARK: - Private methods -

    private func progress(
        lessonOrder: Int,
        totalLessonsCount: Int
    ) -> Double {
        guard totalLessonsCount > 0 else { return 0 }
        return Double(lessonOrder) / Double(totalLessonsCount)
    }
}
