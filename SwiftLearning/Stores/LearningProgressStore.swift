import Foundation

final class LearningProgressStore: ObservableObject {
    @Published private(set) var completedLessonIDs: Set<Int>
    @Published private(set) var xp: Int
    @Published private(set) var totalAnswers: Int
    @Published private(set) var correctAnswers: Int

    private let completedLessonIDsKey = "completedLessonIDs"
    private let xpKey = "xp"
    private let totalAnswersKey = "totalAnswers"
    private let correctAnswersKey = "correctAnswers"
    private let userDefaults: UserDefaults

    var accuracy: Int {
        guard totalAnswers > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(totalAnswers)) * 100)
    }

    var completedLessonsCount: Int {
        completedLessonIDs.count
    }

    var courseProgress: Double {
        guard !LessonData.lessons.isEmpty else { return 0 }
        return Double(completedLessonsCount) / Double(LessonData.lessons.count)
    }

    var courseProgressPercentage: Int {
        Int(courseProgress * 100)
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.completedLessonIDs = Set(userDefaults.array(forKey: completedLessonIDsKey) as? [Int] ?? [])
        self.xp = userDefaults.integer(forKey: xpKey)
        self.totalAnswers = userDefaults.integer(forKey: totalAnswersKey)
        self.correctAnswers = userDefaults.integer(forKey: correctAnswersKey)
    }

    func isCompleted(_ lesson: Lesson) -> Bool {
        completedLessonIDs.contains(lesson.id)
    }

    func isUnlocked(_ lesson: Lesson) -> Bool {
        lesson.id == 1 || completedLessonIDs.contains(lesson.id - 1)
    }

    func completeLesson(_ lesson: Lesson) {
        guard !isCompleted(lesson) else { return }

        completedLessonIDs.insert(lesson.id)
        xp += 20
        saveProgress()
    }

    func recordQuizAnswer(isCorrect: Bool) {
        totalAnswers += 1

        if isCorrect {
            correctAnswers += 1
        }

        saveProgress()
    }

    func resetProgress() {
        completedLessonIDs.removeAll()
        xp = 0
        totalAnswers = 0
        correctAnswers = 0
        saveProgress()
    }

    private func saveProgress() {
        userDefaults.set(Array(completedLessonIDs), forKey: completedLessonIDsKey)
        userDefaults.set(xp, forKey: xpKey)
        userDefaults.set(totalAnswers, forKey: totalAnswersKey)
        userDefaults.set(correctAnswers, forKey: correctAnswersKey)
    }
}
