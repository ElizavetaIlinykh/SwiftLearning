enum AnswerOptionState {
    case neutral
    case selectedCorrect
    case selectedIncorrect
    case correct
}

struct AnswerOptionViewModel {
    // MARK: - Public properties -

    let title: String
    let state: AnswerOptionState
}
