import Combine
import Foundation

@MainActor
final class LessonCompletionViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case completing
        case completed(LessonProgress)
        case failed(String)
    }

    @Published private(set) var state: State = .idle

    private let lessonID: String
    private let lessonsService: LessonsServicing

    init(
        lessonID: String,
        lessonsService: LessonsServicing
    ) {
        self.lessonID = lessonID
        self.lessonsService = lessonsService
    }

    func completeLesson() async -> Bool {
        guard state != .completing else { return false }

        state = .completing

        do {
            let progress = try await lessonsService.completeLesson(id: lessonID)
            state = .completed(progress)
            return true
        } catch {
            state = .failed(error.localizedDescription)
            return false
        }
    }
}
