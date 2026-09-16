import Foundation

struct PracticeSessionState {
    private(set) var tasks: [PracticeTask] = []
    private(set) var currentTaskIndex = 0
    private(set) var selectedAnswerIndex: Int?
    private(set) var correctAnswersCount = 0
    private(set) var totalAnswersCount = 0

    var currentTask: PracticeTask? {
        guard tasks.indices.contains(currentTaskIndex) else { return nil }
        return tasks[currentTaskIndex]
    }

    var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

    var isLastTask: Bool {
        guard !tasks.isEmpty else { return false }
        return currentTaskIndex == tasks.count - 1
    }

    var hasTasks: Bool {
        !tasks.isEmpty
    }

    var taskCount: Int {
        tasks.count
    }

    var currentQuestionNumber: Int {
        currentTaskIndex + 1
    }

    mutating func setTasks(_ tasks: [PracticeTask]) {
        self.tasks = tasks.sorted { $0.order < $1.order }

        guard !self.tasks.isEmpty else {
            currentTaskIndex = 0
            selectedAnswerIndex = nil
            correctAnswersCount = 0
            totalAnswersCount = 0
            return
        }

        currentTaskIndex = min(currentTaskIndex, self.tasks.count - 1)

        if let selectedAnswerIndex, currentTask?.answers.indices.contains(selectedAnswerIndex) == false {
            self.selectedAnswerIndex = nil
        }
    }

    mutating func selectAnswer(id: String) {
        guard selectedAnswerIndex == nil else { return }
        guard let currentTask else { return }
        let orderedAnswers = currentTask.answers.sorted { $0.order < $1.order }
        guard let answerIndex = orderedAnswers.firstIndex(where: { $0.id == id }) else { return }

        selectedAnswerIndex = answerIndex
        totalAnswersCount += 1

        if orderedAnswers[answerIndex].isCorrect {
            correctAnswersCount += 1
        }
    }

    mutating func moveToNextTask() {
        guard currentTaskIndex + 1 < tasks.count else { return }

        currentTaskIndex += 1
        selectedAnswerIndex = nil
    }
}
