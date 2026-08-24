import Foundation

struct PracticeContentViewModel {
    let topics: [PracticeCategoryCardViewModel]
    let loadMoreState: LoadMoreView.State
}

enum PracticeViewState {
    case loading
    case content(PracticeContentViewModel)
    case empty
    case error(String)
}
