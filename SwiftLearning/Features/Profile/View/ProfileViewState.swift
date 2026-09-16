import Foundation

struct ProfileContentViewData {
    let header: ProfileHeaderViewData
    let progress: ProfileProgressViewData
    let statistics: [StatCardViewData]
    let achievements: [AchievementCardViewData]
}

struct ProfileHeaderViewData {
    let name: String
    let email: String
}

struct ProfileProgressViewData {
    let title: String
    let percentTitle: String
    let progress: Double
    let isCourseCompleted: Bool
}

enum ProfileViewState {
    case loading
    case content(ProfileContentViewData)
    case error(String)
}
