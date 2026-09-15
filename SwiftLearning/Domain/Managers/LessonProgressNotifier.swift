import Foundation

final class LessonProgressNotifier {
    final class Observation {
        private weak var notifier: LessonProgressNotifier?
        private let id: UUID

        fileprivate init(
            notifier: LessonProgressNotifier,
            id: UUID
        ) {
            self.notifier = notifier
            self.id = id
        }

        deinit {
            notifier?.removeLessonCompletionObserver(id: id)
        }
    }

    typealias LessonCompletionHandler = (String) -> Void

    // MARK: - Private properties -

    private var lessonCompletionHandlers: [UUID: LessonCompletionHandler] = [:]

    // MARK: - Public methods -

    func observeLessonCompletion(
        _ handler: @escaping LessonCompletionHandler
    ) -> Observation {
        let id = UUID()
        lessonCompletionHandlers[id] = handler

        return Observation(
            notifier: self,
            id: id
        )
    }

    func lessonDidComplete(id: String) {
        for handler in lessonCompletionHandlers.values {
            handler(id)
        }
    }

    // MARK: - Private methods -

    private func removeLessonCompletionObserver(id: UUID) {
        lessonCompletionHandlers[id] = nil
    }
}
