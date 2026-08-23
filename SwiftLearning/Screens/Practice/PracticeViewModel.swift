import Combine
import Foundation

enum PracticeOutput {
    case openTopic(
        id: String,
        title: String
    )
}

@MainActor
final class PracticeViewModel: ObservableObject {
    // MARK: - Private properties -

    private let topicsManager: PracticeTopicsManager
    private let categoryCardBuilder: PracticeCategoryCardBuilder
    private let output: (PracticeOutput) -> Void
    private var topics: [PracticeCategory] = []

    // MARK: - Public properties -

    @Published private(set) var state: PracticeViewState = .loading

    var topicCards: [PracticeCategoryCardViewModel] {
        categoryCardBuilder.build(categories: topics)
    }

    // MARK: - Init -

    init(
        topicsManager: PracticeTopicsManager,
        categoryCardBuilder: PracticeCategoryCardBuilder,
        output: @escaping (PracticeOutput) -> Void
    ) {
        self.topicsManager = topicsManager
        self.categoryCardBuilder = categoryCardBuilder
        self.output = output
    }

    // MARK: - Public methods -

    func loadTopics() async {
        if topics.isEmpty {
            state = .loading
        }

        do {
            topics = try await topicsManager.fetch()
            updateStateFromTopics()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func loadMoreTopicsIfNeeded(currentTopicID: String) async {
        updateContentState(loadMoreState: .loading)

        do {
            topics = try await topicsManager.loadMoreIfNeeded(currentTopicID: currentTopicID)
            updateStateFromTopics()
        } catch is CancellationError {
            updateStateFromTopics()
        } catch {
            updateStateFromTopics()
        }
    }

    func retryLoadMoreTopics() async {
        updateContentState(loadMoreState: .loading)

        do {
            topics = try await topicsManager.loadMore()
            updateStateFromTopics()
        } catch is CancellationError {
            updateStateFromTopics()
        } catch {
            updateStateFromTopics()
        }
    }

    func refreshTopics() async {
        do {
            topics = try await topicsManager.refresh()
            updateStateFromTopics()
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func selectTopic(id: String) {
        guard let topic = topics.first(where: { $0.id == id }) else {
            return
        }

        output(
            .openTopic(
                id: topic.id,
                title: topic.title
            )
        )
    }

    // MARK: - Private properties -

    private var loadMoreState: LoadMoreView.State {
        switch topicsManager.moreLoadingState {
        case .loading:
            .loading
        case let .failed(error):
            .error(UserFacingErrorMessage.message(for: error))
        case .idle:
            .idle
        }
    }

    // MARK: - Private methods -

    private func updateStateFromTopics() {
        if topics.isEmpty {
            state = .empty
        } else {
            state = .content(makeContentViewModel())
        }
    }

    private func makeContentViewModel(
        loadMoreState: LoadMoreView.State? = nil
    ) -> PracticeContentViewModel {
        PracticeContentViewModel(
            topics: topicCards,
            loadMoreState: loadMoreState ?? self.loadMoreState
        )
    }

    private func updateContentState(loadMoreState: LoadMoreView.State) {
        guard case .content = state else {
            return
        }

        state = .content(
            makeContentViewModel(loadMoreState: loadMoreState)
        )
    }
}
