import Foundation

struct PracticeContentViewModel {
    let topics: [PracticeCategoryCardViewModel]
    let loadMoreState: LoadMoreView.State
}

struct PracticeCategoryCardViewModel: Identifiable {
    let id: String
    let title: String
    let description: String
    let tasksCountTitle: String
    let systemImage: String
}

enum PracticeViewState {
    case loading
    case content(PracticeContentViewModel)
    case empty
    case error(String)
}
