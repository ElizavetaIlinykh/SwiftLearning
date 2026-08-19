import Combine
import Foundation

enum LessonCodeTaskLoadingState: Equatable {
    case idle
    case loading
    case loaded(LessonCodeTask)
    case notAvailable
    case failed(String)
}

@MainActor
final class LessonCodeTaskManager: ObservableObject {
    // MARK: - Private properties -

    @Published private(set) var state: LessonCodeTaskLoadingState = .idle
    private let lessonID: String
    private let lessonsService: LessonsServicing

    // MARK: - Init -

    init(
        lessonID: String,
        lessonsService: LessonsServicing
    ) {
        self.lessonID = lessonID
        self.lessonsService = lessonsService
    }

    // MARK: - Public methods -

    func loadCodeTask() async {
        guard state != .loading else { return }

        state = .loading

        do {
            let codeTask = try await lessonsService.fetchLessonCodeTask(lessonID: lessonID)
            state = .loaded(codeTask)
        } catch LessonCodeTaskError.notFound {
            state = .notAvailable
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
