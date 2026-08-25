import Foundation

enum LearnViewState {
    case loading
    case content(LearnContentViewModel)
    case empty
    case error(String)
}
