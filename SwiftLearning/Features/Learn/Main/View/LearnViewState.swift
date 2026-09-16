import Foundation

enum LearnViewState {
    case loading
    case content(LearnContentViewData)
    case empty
    case error(String)
}
