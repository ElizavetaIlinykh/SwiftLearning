import Combine
import Foundation

@MainActor
final class LessonViewModel: ObservableObject {
    // MARK: - Private properties -

    private let lessonDetailsManager: LessonDetailsManager
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public properties -

    let totalLessonsCount: Int

    // MARK: - Init -

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

    // MARK: - Public methods -

    func loadLesson() async {
        await lessonDetailsManager.loadLesson()
    }

    // MARK: - Private methods -

    private func bindLessonDetailsManager() {
        lessonDetailsManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
