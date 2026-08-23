import Foundation

struct ProfileContentBuilder {
    // MARK: - Public methods -

    func build(content: ProfileContent) -> ProfileContentViewModel {
        ProfileContentViewModel(
            header: ProfileHeaderViewModel(
                name: content.user.name,
                email: content.user.email
            ),
            progress: progressViewModel(statistics: content.statistics),
            statistics: statisticCards(statistics: content.statistics),
            achievements: achievements(statistics: content.statistics)
        )
    }

    // MARK: - Private methods -

    private func progressViewModel(statistics: UserStatistics) -> ProfileProgressViewModel {
        ProfileProgressViewModel(
            title: "\(statistics.completedLessonsCount) of \(statistics.totalLessonsCount) lessons completed",
            percentTitle: "\(statistics.progressPercent)%",
            progress: Double(statistics.progressPercent) / 100,
            isCourseCompleted: isCourseCompleted(statistics)
        )
    }

    private func statisticCards(statistics: UserStatistics) -> [StatCardViewModel] {
        [
            StatCardViewModel(title: "Level", value: "\(statistics.currentLevel)", systemImage: "bolt.fill"),
            StatCardViewModel(
                title: "Lessons",
                value: "\(statistics.completedLessonsCount) / \(statistics.totalLessonsCount)",
                systemImage: "book.fill"
            ),
            StatCardViewModel(title: "Progress", value: "\(statistics.progressPercent)%", systemImage: "target")
        ]
    }

    private func achievements(statistics: UserStatistics) -> [Achievement] {
        let completedCount = statistics.completedLessonsCount

        return [
            Achievement(
                id: "first-step",
                title: "First Step",
                description: "Complete your first lesson",
                systemImage: "figure.walk",
                isUnlocked: completedCount >= 1
            ),
            Achievement(
                id: "swift-beginner",
                title: "Swift Beginner",
                description: "Complete 3 lessons",
                systemImage: "chevron.left.forwardslash.chevron.right",
                isUnlocked: completedCount >= 3
            ),
            Achievement(
                id: "halfway-there",
                title: "Halfway There",
                description: "Complete 4 lessons",
                systemImage: "flag.fill",
                isUnlocked: completedCount >= 4
            ),
            Achievement(
                id: "swift-explorer",
                title: "Swift Explorer",
                description: "Complete all lessons",
                systemImage: "trophy.fill",
                isUnlocked: isCourseCompleted(statistics)
            )
        ]
    }

    private func isCourseCompleted(_ statistics: UserStatistics) -> Bool {
        statistics.totalLessonsCount > 0 && statistics.completedLessonsCount == statistics.totalLessonsCount
    }
}
