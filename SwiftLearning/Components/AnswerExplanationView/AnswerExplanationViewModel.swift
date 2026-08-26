struct AnswerExplanationViewModel {
    // MARK: - Public properties -

    let isCorrect: Bool
    let explanation: String
    let correctAnswer: String?

    var accessibilityLabel: String {
        var parts = [isCorrect ? "Correct" : "Incorrect"]

        if let correctAnswer {
            parts.append("Correct answer: \(correctAnswer)")
        }

        parts.append(explanation)
        return parts.joined(separator: ". ")
    }
}
