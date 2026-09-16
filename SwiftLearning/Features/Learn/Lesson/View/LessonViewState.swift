import Foundation

enum LessonViewState {
    case loading
    case content(
        progressViewData: LessonProgressViewData,
        contentViewData: LessonContentViewData
    )
    case error(String)
}
