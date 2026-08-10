import Combine
import Foundation

@MainActor
final class LessonViewModel: ObservableObject {
    private let lessonDetailsManager: LessonDetailsManager
    private var cancellables: Set<AnyCancellable> = []

    let totalLessonsCount: Int

    var state: LessonDetailsLoadingState {
        lessonDetailsManager.state
    }

    init(
        lessonDetailsManager: LessonDetailsManager,
        totalLessonsCount: Int
    ) {
        self.lessonDetailsManager = lessonDetailsManager
        self.totalLessonsCount = totalLessonsCount
        bindLessonDetailsManagerUpdates()
    }

    func loadLesson() async {
        await lessonDetailsManager.loadLesson()
    }

    private func bindLessonDetailsManagerUpdates() {
        lessonDetailsManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
