import Foundation

enum LessonCodeTaskPrimaryAction {
    case checkAnswer
    case finishLesson
}

struct LessonCodeTaskPrimaryButtonContext {
    let viewState: LessonCodeTaskViewState
    let answerState: AnswerState
    let completionState: LessonCompletionState
}

struct LessonCodeTaskPrimaryButtonViewModel {
    let title: String
    let isDisabled: Bool
    let action: LessonCodeTaskPrimaryAction
}

struct LessonCodeTaskPrimaryButtonBuilder {
    // MARK: - Public methods -

    func build(
        context: LessonCodeTaskPrimaryButtonContext
    ) -> LessonCodeTaskPrimaryButtonViewModel {
        switch context.viewState {
        case .notAvailable:
            finishLessonButton(completionState: context.completionState)
        default:
            if context.answerState == .correct {
                finishLessonButton(completionState: context.completionState)
            } else {
                checkAnswerButton()
            }
        }
    }

    // MARK: - Private methods -

    private func checkAnswerButton() -> LessonCodeTaskPrimaryButtonViewModel {
        LessonCodeTaskPrimaryButtonViewModel(
            title: L10n.string("codeTask.checkAnswer"),
            isDisabled: false,
            action: .checkAnswer
        )
    }

    private func finishLessonButton(
        completionState: LessonCompletionState
    ) -> LessonCodeTaskPrimaryButtonViewModel {
        LessonCodeTaskPrimaryButtonViewModel(
            title: completionButtonTitle(completionState: completionState),
            isDisabled: isCompleting(completionState: completionState),
            action: .finishLesson
        )
    }

    private func completionButtonTitle(
        completionState: LessonCompletionState
    ) -> String {
        isCompleting(completionState: completionState) ? L10n.string("codeTask.completing") : L10n.string("codeTask.finishLesson")
    }

    private func isCompleting(
        completionState: LessonCompletionState
    ) -> Bool {
        if case .completing = completionState {
            return true
        }
        return false
    }
}
