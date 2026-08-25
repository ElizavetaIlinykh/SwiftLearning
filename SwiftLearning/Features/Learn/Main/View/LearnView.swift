import SwiftUI

struct LearnView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: LearnViewModel

    // MARK: - Init -

    init(viewModel: LearnViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Public properties -

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                header

                content
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchLessons()
        }
        .refreshable {
            await viewModel.refreshLessons()
        }
        .onScrollTargetVisibilityChange(
            idType: String.self,
            threshold: 0.3
        ) { visibleIDs in
            loadMoreIfNeeded(visibleLessonIDs: visibleIDs)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Swift Learning")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Continue learning Swift")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView

        case let .error(message):
            errorView(message: message)

        case .empty:
            emptyView

        case let .content(contentViewModel):
            lessonsContent(contentViewModel)
        }
    }

    private func lessonsContent(_ contentViewModel: LearnContentViewModel) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressCardView(
                viewModel: contentViewModel.progressCard,
                onAction: viewModel.handleProgressCardAction
            )

            VStack(alignment: .leading, spacing: 14) {
                Text("Course")
                    .font(.title2)
                    .fontWeight(.bold)

                LazyVStack(alignment: .leading, spacing: 14) {
                    ForEach(contentViewModel.lessonCards) { lessonCard in
                        LessonCardView(viewModel: lessonCard) {
                            viewModel.selectLesson(id: lessonCard.id)
                        }
                    }
                }
                .scrollTargetLayout()

                LoadMoreView(state: contentViewModel.loadMoreState) {
                    await viewModel.retryLoadMoreLessons()
                }
            }
        }
    }

    // MARK: - Private methods -

    private func loadMoreIfNeeded(visibleLessonIDs: [String]) {
        let preloadIDs = viewModel.lessonCards
            .suffix(5)
            .map(\.id)

        guard preloadIDs.contains(where: visibleLessonIDs.contains) else {
            return
        }

        Task {
            await viewModel.loadMoreLessons()
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: "Loading lessons")
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: "Could not load lessons",
            message: message
        ) {
            Task {
                await viewModel.fetchLessons()
            }
        }
    }

    private var emptyView: some View {
        EmptyStateView(
            title: "No lessons yet",
            message: "Lessons will appear here when the server returns them."
        )
    }
}

#Preview {
    LearnModuleAssembler.assemble(
        dependencies: AppDependenciesAssembler.assemble(),
        output: { _ in }
    )
}
