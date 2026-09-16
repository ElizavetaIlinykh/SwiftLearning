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
            .padding(AppSpacing.screen)
        }
        .background(AppColors.background)
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
        case let .content(progressViewData, contentViewData):
            lessonContent(
                contentViewData,
                progressViewData: progressViewData
            )
        }
    }

    // MARK: - Private methods -

    private func lessonContent(
        _ contentViewData: LessonContentViewData,
        progressViewData: LessonProgressViewData
    ) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            lessonProgress(progressViewData)

            VStack(alignment: .leading, spacing: 12) {
                Text(contentViewData.theorySectionTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textSecondary)

                Text(contentViewData.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)

                Text(contentViewData.theory)
                    .font(.body)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(AppColors.textPrimary)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(contentViewData.codeSectionTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textSecondary)

                CodeBlockView(
                    viewData: CodeBlockViewData(code: contentViewData.codeExample)
                )
            }

            PrimaryButtonView(title: L10n.string("common.continue")) {
                viewModel.continueToQuiz(lessonID: contentViewData.lessonID)
            }
        }
    }

    private func lessonProgress(_ progressViewData: LessonProgressViewData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(progressViewData.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textSecondary)

                Spacer()

                Text(progressViewData.valueTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textSecondary)
            }

            AppProgressBarView(value: progressViewData.progress)
        }
    }

    private var loadingView: some View {
        LoadingStateView(title: L10n.string("lesson.loading"))
    }

    private func errorView(message: String) -> some View {
        ErrorStateView(
            title: L10n.string("lesson.error.load"),
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
