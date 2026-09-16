enum AnswerOptionState {
    case neutral
    case selectedCorrect
    case selectedIncorrect
    case correct
}

struct AnswerOptionViewData {
    // MARK: - Public properties -

    let title: String
    let state: AnswerOptionState
}
