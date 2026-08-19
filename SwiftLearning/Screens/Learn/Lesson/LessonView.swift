import SwiftUI

struct LessonView: View {
    // MARK: - Private properties -

    // MARK: - Init -

    @Environment(AppRouter.self) private var router
    @StateObject private var viewModel: LessonViewModel
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
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadLesson()
        }
        .refreshable {
            await viewModel.loadLesson()
        }
    }

    private var navigationTitle: String {
        guard case let .loaded(lesson) = viewModel.state else { return "Lesson" }
        return lesson.title
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case let .failed(message):
            errorView(message: message)
        case let .loaded(lesson):
            lessonContent(lesson)
        }
    }

    // MARK: - Private methods -

    private func lessonContent(_ lesson: LessonDetails) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            lessonProgress(lesson)

            VStack(alignment: .leading, spacing: 12) {
                Text("THEORY")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                Text(lesson.title)
                    .font(.title)
                    .fontWeight(.bold)

                Text(lesson.theory)
                    .font(.body)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("CODE EXAMPLE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                CodeBlockView(code: lesson.codeExample)
            }

            PrimaryButton(title: "Continue") {
                router.push(.quiz(lessonID: lesson.id))
            }
        }
    }

    private func lessonProgress(_ lesson: LessonDetails) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Lesson \(lesson.order) of \(viewModel.totalLessonsCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(lesson.order) / \(viewModel.totalLessonsCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: courseProgress(for: lesson))
                .tint(.accentColor)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()
            Text("Loading lesson")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private func errorView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Could not load lesson")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton(title: "Try Again") {
                Task {
                    await viewModel.loadLesson()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private func courseProgress(for lesson: LessonDetails) -> Double {
        guard viewModel.totalLessonsCount > 0 else { return 0 }
        return Double(lesson.order) / Double(viewModel.totalLessonsCount)
    }
}

#Preview {
    NavigationStack {
        LessonModuleAssembler.assemble(
            lessonID: "57451d1d-27d4-40a3-86a1-3c06b176be68",
            totalLessonsCount: 1,
            dependencies: AppDependenciesAssembler.assemble()
        )
        .environment(AppRouter())
    }
}
