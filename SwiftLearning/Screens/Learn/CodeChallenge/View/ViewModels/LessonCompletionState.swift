import Foundation

enum LessonCompletionState: Equatable {
    case idle
    case completing
    case completed(LessonProgress)
    case failed(String)
}
