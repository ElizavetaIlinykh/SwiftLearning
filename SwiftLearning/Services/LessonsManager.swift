import Combine
import Foundation

enum LessonsLoadingState: Equatable {
    case idle
    case loading
    case loaded([LessonSummary])
    case failed(String)
}

@MainActor
final class LessonsManager: ObservableObject {
    @Published private(set) var state: LessonsLoadingState = .idle

    private let lessonsService: LessonsServicing

    init(lessonsService: LessonsServicing) {
        self.lessonsService = lessonsService
    }

    func loadLessons() async {
        guard state != .loading else { return }

        state = .loading

        do {
            let lessons = try await lessonsService.fetchLessons()
            state = .loaded(lessons)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
