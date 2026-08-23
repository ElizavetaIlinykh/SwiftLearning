import Foundation

struct LearnContentViewModel {
    let progressCard: ProgressCardViewModel
    let lessonCards: [LessonCardViewModel]
    let loadMoreState: LoadMoreView.State
}

enum LearnViewState {
    case loading
    case content(LearnContentViewModel)
    case empty
    case error(String)
}
