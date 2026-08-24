import Foundation

struct ProfileContentViewModel {
    let header: ProfileHeaderViewModel
    let progress: ProfileProgressViewModel
    let statistics: [StatCardViewModel]
    let achievements: [AchievementCardViewModel]
}

struct ProfileHeaderViewModel {
    let name: String
    let email: String
}

struct ProfileProgressViewModel {
    let title: String
    let percentTitle: String
    let progress: Double
    let isCourseCompleted: Bool
}

enum ProfileViewState {
    case loading
    case content(ProfileContentViewModel)
    case error(String)
}
