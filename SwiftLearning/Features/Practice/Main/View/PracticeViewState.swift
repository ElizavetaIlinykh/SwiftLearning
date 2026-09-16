import Foundation

struct PracticeContentViewData {
    let topics: [PracticeCategoryCardViewData]
    let loadMoreState: LoadMoreView.State
}

enum PracticeViewState {
    case loading
    case content(PracticeContentViewData)
    case empty
    case error(String)
}
