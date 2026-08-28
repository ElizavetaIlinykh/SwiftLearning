import Foundation

struct LessonContentBuilder {
    // MARK: - Public methods -

    func build(lesson: LessonDetails) -> LessonContentViewModel {
        LessonContentViewModel(
            lessonID: lesson.id,
            theorySectionTitle: L10n.string("lesson.section.theory"),
            title: lesson.title,
            theory: lesson.theory ?? "",
            codeSectionTitle: L10n.string("lesson.section.codeExample"),
            codeExample: lesson.codeExample ?? ""
        )
    }
}
