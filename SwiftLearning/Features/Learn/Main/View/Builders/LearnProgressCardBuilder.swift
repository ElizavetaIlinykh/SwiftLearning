import Foundation

struct LearnProgressCardBuilder {
    // MARK: - Private properties -

    private let courseTitle: String

    // MARK: - Init -

    init(courseTitle: String = "Swift Basics") {
        self.courseTitle = courseTitle
    }

    // MARK: - Public methods -

    func build(lessons: [LessonSummary]) -> ProgressCardViewModel {
        let completedLessonsCount = lessons.filter { $0.status == .completed }.count

        return ProgressCardViewModel(
            courseTitle: courseTitle,
            completedLessonsTitle: completedLessonsTitle(
                completedLessonsCount: completedLessonsCount,
                totalLessonsCount: lessons.count
            ),
            completedLessonsCount: completedLessonsCount,
            totalLessonsCount: lessons.count,
            progress: progress(
                completedLessonsCount: completedLessonsCount,
                totalLessonsCount: lessons.count
            ),
            state: state(
                completedLessonsCount: completedLessonsCount,
                totalLessonsCount: lessons.count
            )
        )
    }

    // MARK: - Private methods -

    private func progress(
        completedLessonsCount: Int,
        totalLessonsCount: Int
    ) -> Double {
        guard totalLessonsCount > 0 else {
            return 0
        }

        return Double(completedLessonsCount) / Double(totalLessonsCount)
    }

    private func completedLessonsTitle(
        completedLessonsCount: Int,
        totalLessonsCount: Int
    ) -> String {
        "\(completedLessonsCount) of \(totalLessonsCount) lessons completed"
    }

    private func state(
        completedLessonsCount: Int,
        totalLessonsCount: Int
    ) -> ProgressCardState {
        guard totalLessonsCount > 0 else {
            return .notStarted
        }

        if completedLessonsCount == totalLessonsCount {
            return .completed
        }

        if completedLessonsCount == 0 {
            return .notStarted
        }

        return .inProgress
    }
}
