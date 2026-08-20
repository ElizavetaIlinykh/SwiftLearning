import Combine
import Foundation

enum LessonQuizLoadingState: Equatable {
    case idle
    case loading
    case loaded([LessonQuizQuestion])
    case failed(String)
}

@MainActor
final class LessonQuizManager: ObservableObject {
    // MARK: - Private properties -

    @Published private(set) var state: LessonQuizLoadingState = .idle
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

    func loadQuestions() async {
        guard state != .loading else { return }

        state = .loading

        do {
            let questions = try await lessonsService.fetchLessonQuestions(lessonID: lessonID)
            state = .loaded(questions)
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }
}
