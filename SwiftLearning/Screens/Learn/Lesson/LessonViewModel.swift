import Combine
import Foundation

@MainActor
final class LessonViewModel: ObservableObject {
    private let lessonDetailsManager: LessonDetailsManager
    private var cancellables: Set<AnyCancellable> = []

    let totalLessonsCount: Int

    @Published private(set) var state: LessonDetailsLoadingState

    init(
        lessonDetailsManager: LessonDetailsManager,
        totalLessonsCount: Int
    ) {
        self.lessonDetailsManager = lessonDetailsManager
        self.totalLessonsCount = totalLessonsCount
        state = lessonDetailsManager.state

        bindLessonDetailsManager()
    }

    func loadLesson() async {
        await lessonDetailsManager.loadLesson()
    }

    private func bindLessonDetailsManager() {
        lessonDetailsManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
