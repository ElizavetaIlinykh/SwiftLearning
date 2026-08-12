import Foundation
import Observation

@Observable
final class AppRouter {
    var selectedTab: AppTab = .lessons

    var lessonsPath: [LessonsRoute] = []
    var practicePath: [PracticeRoute] = []
    var profilePath: [ProfileRoute] = []

    func push(_ route: LessonsRoute) {
        lessonsPath.append(route)
    }

    func push(_ route: PracticeRoute) {
        practicePath.append(route)
    }

    func push(_ route: ProfileRoute) {
        profilePath.append(route)
    }

    func pop() {
        switch selectedTab {
        case .lessons:
            popLessons()
        case .practice:
            popPractice()
        case .profile:
            popProfile()
        }
    }

    func popToRoot() {
        switch selectedTab {
        case .lessons:
            popLessonsToRoot()
        case .practice:
            popPracticeToRoot()
        case .profile:
            popProfileToRoot()
        }
    }

    func popLessons() {
        guard !lessonsPath.isEmpty else { return }
        lessonsPath.removeLast()
    }

    func popPractice() {
        guard !practicePath.isEmpty else { return }
        practicePath.removeLast()
    }

    func popProfile() {
        guard !profilePath.isEmpty else { return }
        profilePath.removeLast()
    }

    func popLessonsToRoot() {
        lessonsPath.removeAll()
    }

    func popPracticeToRoot() {
        practicePath.removeAll()
    }

    func popProfileToRoot() {
        profilePath.removeAll()
    }

    func restartPractice(topicID: String, topicTitle: String) {
        practicePath = [.exercise(id: topicID, title: topicTitle, attemptID: UUID())]
    }
}

enum AppTab: Hashable {
    case lessons
    case practice
    case profile
}

enum LessonsRoute: Hashable {
    case lesson(id: String, totalLessonsCount: Int)
    case quiz(lessonID: String)
    case codeTask(lessonID: String)
    case result(lessonID: String)
}

enum PracticeRoute: Hashable {
    case topic(id: String, title: String)
    case exercise(id: String, title: String, attemptID: UUID)
    case result(topicID: String, topicTitle: String, correctAnswersCount: Int, totalQuestions: Int)
}

enum ProfileRoute: Hashable {
    case statistics
    case settings
}
