import Foundation

struct LessonContentBuilder {
    // MARK: - Public methods -

    func build(lesson: LessonDetails) -> LessonContentViewModel {
        LessonContentViewModel(
            lessonID: lesson.id,
            theorySectionTitle: "THEORY",
            title: lesson.title,
            theory: lesson.theory,
            codeSectionTitle: "CODE EXAMPLE",
            codeExample: lesson.codeExample
        )
    }
}
