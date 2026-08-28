import Foundation

struct PracticeCategoryCardBuilder {
    // MARK: - Public methods -

    func build(categories: [PracticeCategory]) -> [PracticeCategoryCardViewModel] {
        categories
            .sorted { $0.order < $1.order }
            .map(build(category:))
    }

    // MARK: - Private methods -

    private func build(category: PracticeCategory) -> PracticeCategoryCardViewModel {
        PracticeCategoryCardViewModel(
            id: category.id,
            title: category.title,
            description: category.description,
            tasksCountTitle: L10n.format("practice.tasksCount", category.tasksCount),
            systemImage: category.systemImage
        )
    }
}
