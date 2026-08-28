struct AnswerExplanationViewModel {
    // MARK: - Public properties -

    let isCorrect: Bool
    let explanation: String
    let correctAnswer: String?

    var accessibilityLabel: String {
        var parts = [isCorrect ? L10n.string("answer.correct") : L10n.string("answer.incorrect")]

        if let correctAnswer {
            parts.append(L10n.format("answer.correctAnswer", correctAnswer))
        }

        parts.append(explanation)
        return parts.joined(separator: ". ")
    }
}
