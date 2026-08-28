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
            title: L10n.format("learn.progress.completedLessons", statistics.completedLessonsCount, statistics.totalLessonsCount),
            percentTitle: "\(statistics.progressPercent)%",
            progress: Double(statistics.progressPercent) / 100,
            isCourseCompleted: isCourseCompleted(statistics)
        )
    }

    private func statisticCards(statistics: UserStatistics) -> [StatCardViewModel] {
        [
            StatCardViewModel(title: L10n.string("profile.stat.level"), value: "\(statistics.currentLevel)", systemImage: "bolt.fill"),
            StatCardViewModel(
                title: L10n.string("profile.stat.lessons"),
                value: "\(statistics.completedLessonsCount) / \(statistics.totalLessonsCount)",
                systemImage: "book.fill"
            ),
            StatCardViewModel(title: L10n.string("profile.stat.progress"), value: "\(statistics.progressPercent)%", systemImage: "target")
        ]
    }

    private func achievements(statistics: UserStatistics) -> [AchievementCardViewModel] {
        let completedCount = statistics.completedLessonsCount

        return [
            AchievementCardViewModel(
                id: "first-step",
                title: L10n.string("profile.achievement.firstStep.title"),
                description: L10n.string("profile.achievement.firstStep.description"),
                systemImage: "figure.walk",
                isUnlocked: completedCount >= 1
            ),
            AchievementCardViewModel(
                id: "swift-beginner",
                title: L10n.string("profile.achievement.swiftBeginner.title"),
                description: L10n.string("profile.achievement.swiftBeginner.description"),
                systemImage: "chevron.left.forwardslash.chevron.right",
                isUnlocked: completedCount >= 3
            ),
            AchievementCardViewModel(
                id: "halfway-there",
                title: L10n.string("profile.achievement.halfwayThere.title"),
                description: L10n.string("profile.achievement.halfwayThere.description"),
                systemImage: "flag.fill",
                isUnlocked: completedCount >= 4
            ),
            AchievementCardViewModel(
                id: "swift-explorer",
                title: L10n.string("profile.achievement.swiftExplorer.title"),
                description: L10n.string("profile.achievement.swiftExplorer.description"),
                systemImage: "trophy.fill",
                isUnlocked: isCourseCompleted(statistics)
            )
        ]
    }

    private func isCourseCompleted(_ statistics: UserStatistics) -> Bool {
        statistics.totalLessonsCount > 0 && statistics.completedLessonsCount == statistics.totalLessonsCount
    }
}
