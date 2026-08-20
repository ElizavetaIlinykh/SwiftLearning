import SwiftUI

struct LearnView: View {
    // MARK: - Private properties -

    // MARK: - Init -

    @StateObject private var viewModel: LearnViewModel
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
        .onAppear {
            Task {
                await viewModel.fetchLessons()
            }
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
        case .idle, .loading:
            loadingView

        case let .failed(message):
            errorView(message: message)

        case let .loaded(lessons, _):
            if lessons.isEmpty {
                emptyView
            } else {
                lessonsContent
            }
        }
    }

    @ViewBuilder
    private var lessonsContent: some View {
        ProgressCard(viewModel: viewModel.progressCard)

        VStack(alignment: .leading, spacing: 14) {
            Text("Course")
                .font(.title2)
                .fontWeight(.bold)

            LazyVStack(alignment: .leading, spacing: 14) {
                ForEach(viewModel.lessonCards) { lessonCard in
                    LessonCard(viewModel: lessonCard) {
                        viewModel.selectLesson(id: lessonCard.id)
                    }
                }
            }
            .scrollTargetLayout()

            LoadMoreView(state: viewModel.loadMoreState) {
                await viewModel.retryLoadMoreLessons()
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
        VStack(spacing: 14) {
            ProgressView()

            Text("Loading lessons")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private func errorView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Could not load lessons")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Try Again") {
                Task {
                    await viewModel.fetchLessons()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .stroke(
                Color.primary.opacity(0.06),
                lineWidth: 1
            )
        )
    }

    private var emptyView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No lessons yet")
                .font(.headline)

            Text("Lessons will appear here when the server returns them.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .stroke(
                Color.primary.opacity(0.06),
                lineWidth: 1
            )
        )
    }
}

#Preview {
    let router = AppRouter()

    LearnModuleAssembler
        .assemble(
            dependencies: AppDependenciesAssembler.assemble(),
            router: router
        )
        .environment(router)
}
