import Foundation

enum LessonViewState {
    case loading
    case content(
        progressViewModel: LessonProgressViewModel,
        contentViewModel: LessonContentViewModel
    )
    case error(String)
}
