import Foundation

struct ProfileContentViewModel {
    let header: ProfileHeaderViewModel
    let progress: ProfileProgressViewModel
    let statistics: [StatCardViewModel]
    let achievements: [Achievement]
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

struct StatCardViewModel: Identifiable {
    let id: String
    let title: String
    let value: String
    let systemImage: String

    init(title: String, value: String, systemImage: String) {
        id = title
        self.title = title
        self.value = value
        self.systemImage = systemImage
    }
}

enum ProfileViewState {
    case loading
    case content(ProfileContentViewModel)
    case error(String)
}
