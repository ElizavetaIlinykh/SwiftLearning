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
            .padding(AppSpacing.screen)
        }
        .background(AppColors.screenBackground)
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
            Text(L10n.string("learn.header.title"))
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(L10n.string("learn.header.subtitle"))
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
        let currentLesson = contentViewModel.lessonCards.first(where: isCurrentLesson)
        let courseLessons = contentViewModel.lessonCards.filter { lesson in
            lesson.id != currentLesson?.id
        }

        return VStack(alignment: .leading, spacing: AppSpacing.section) {
            ProgressCardView(viewModel: contentViewModel.progressCard)

            if let currentLesson {
                currentLessonSection(currentLesson)
            }

            courseSection(
                lessons: courseLessons,
                loadMoreState: contentViewModel.loadMoreState
            )
        }
    }

    private func currentLessonSection(_ lesson: LessonCardViewModel) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text(L10n.string("learn.currentLesson.section"))
                    .font(.title2)
                    .fontWeight(.bold)

                Text(L10n.string("learn.currentLesson.subtitle"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {
                viewModel.selectLesson(id: lesson.id)
            } label: {
                HStack(alignment: .center, spacing: AppSpacing.card) {
                    VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                        Text(String(format: "%02d", lesson.order))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentColor)

                        Text(lesson.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        if !lesson.description.isEmpty {
                            Text(lesson.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                    }

                    Spacer(minLength: AppSpacing.medium)

                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
                .appCard(
                    background: AppColors.accentFill,
                    borderColor: Color.accentColor.opacity(AppOpacity.activeBorder),
                    radius: AppRadius.largeCard,
                    padding: AppSpacing.section,
                    lineWidth: 1.5
                )
            }
            .buttonStyle(.plain)
        }
    }

    private func courseSection(
        lessons: [LessonCardViewModel],
        loadMoreState: LoadMoreView.State
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.large) {
            Text(L10n.string("learn.course.section"))
                .font(.title2)
                .fontWeight(.bold)

            if !lessons.isEmpty {
                LazyVStack(alignment: .leading, spacing: AppSpacing.large) {
                    ForEach(lessons) { lessonCard in
                        LessonCardView(viewModel: lessonCard) {
                            viewModel.selectLesson(id: lessonCard.id)
                        }
                    }
                }
                .scrollTargetLayout()
            }

            LoadMoreView(state: loadMoreState) {
                await viewModel.retryLoadMoreLessons()
            }
        }
    }

    // MARK: - Private methods -

    private func isCurrentLesson(_ lesson: LessonCardViewModel) -> Bool {
        if case .current = lesson.state {
            return true
        }

        return false
    }

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
        LoadingStateView(title: L10n.string("learn.loadingLessons"))
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: L10n.string("learn.error.loadLessons"),
            message: message
        ) {
            Task {
                await viewModel.fetchLessons()
            }
        }
    }

    private var emptyView: some View {
        EmptyStateView(
            title: L10n.string("learn.empty.title"),
            message: L10n.string("learn.empty.message")
        )
    }
}

#Preview {
    LearnModuleAssembler.assemble(
        dependencies: AppDependenciesAssembler.assemble(),
        output: { _ in }
    )
}
