import Foundation

enum LessonCodeTaskViewState {
    case loading
    case content(LessonCodeTaskContentViewData)
    case notAvailable
    case error(String)
}
