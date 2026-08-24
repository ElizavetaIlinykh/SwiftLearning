import SwiftUI

struct LessonView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: LessonViewModel

    // MARK: - Init -

    init(viewModel: LessonViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Public properties -

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                content
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadLesson()
        }
        .refreshable {
            await viewModel.loadLesson()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case let .error(message):
            errorView(message: message)
        case let .content(progressViewModel, contentViewModel):
            lessonContent(
                contentViewModel,
                progressViewModel: progressViewModel
            )
        }
    }

    // MARK: - Private methods -

    private func lessonContent(
        _ contentViewModel: LessonContentViewModel,
        progressViewModel: LessonProgressViewModel
    ) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            lessonProgress(progressViewModel)

            VStack(alignment: .leading, spacing: 12) {
                Text(contentViewModel.theorySectionTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                Text(contentViewModel.title)
                    .font(.title)
                    .fontWeight(.bold)

                Text(contentViewModel.theory)
                    .font(.body)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(contentViewModel.codeSectionTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                CodeBlockView(
                    viewModel: CodeBlockViewModel(code: contentViewModel.codeExample)
                )
            }

            PrimaryButton(title: "Continue") {
                viewModel.continueToQuiz(lessonID: contentViewModel.lessonID)
            }
        }
    }

    private func lessonProgress(_ progressViewModel: LessonProgressViewModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(progressViewModel.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(progressViewModel.valueTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progressViewModel.progress)
                .tint(.accentColor)
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: "Loading lesson")
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: "Could not load lesson",
            message: message
        ) {
            Task {
                await viewModel.loadLesson()
            }
        }
    }
}

#Preview {
    NavigationStack {
        LessonModuleAssembler.assemble(
            lessonID: "57451d1d-27d4-40a3-86a1-3c06b176be68",
            totalLessonsCount: 1,
            dependencies: AppDependenciesAssembler.assemble(),
            output: { _ in }
        )
    }
}
