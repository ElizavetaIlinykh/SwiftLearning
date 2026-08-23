import Foundation

enum LessonCodeTaskViewState {
    case loading
    case content(LessonCodeTaskContentViewModel)
    case notAvailable
    case error(String)
}
