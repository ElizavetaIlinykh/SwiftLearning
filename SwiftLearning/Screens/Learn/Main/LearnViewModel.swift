import Combine
import Foundation

@MainActor
final class LearnViewModel: ObservableObject {
    private let lessonsManager: LessonsManager
    private var cancellables: Set<AnyCancellable> = []

    var state: LessonsLoadingState {
        lessonsManager.state
    }

    var lessons: [LessonSummary] {
        guard case .loaded(let lessons) = state else { return [] }
        return lessons
    }

    var lessonCards: [LessonCardViewModel] {
        lessons
            .sorted { $0.order < $1.order }
            .map { lesson in
                LessonCardViewModel(
                    id: lesson.id,
                    title: lesson.title,
                    description: lesson.description,
                    order: lesson.order,
                    state: lessonState(for: lesson.status)
                )
            }
    }

    var completedLessonsCount: Int {
        lessons.filter { $0.status == .completed }.count
    }

    init() {
        self.lessonsManager = LessonsManager()
        bindLessonsManagerUpdates()
    }

    init(lessonsManager: LessonsManager) {
        self.lessonsManager = lessonsManager
        bindLessonsManagerUpdates()
    }

    private func bindLessonsManagerUpdates() {
        lessonsManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func loadLessons() async {
        await lessonsManager.loadLessons()
    }

    private func lessonState(for status: LessonStatus) -> LessonState {
        switch status {
        case .completed:
            return .completed
        case .available:
            return .current
        case .locked:
            return .locked
        }
    }
}
