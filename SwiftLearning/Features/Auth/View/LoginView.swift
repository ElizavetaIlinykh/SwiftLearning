import SwiftUI

struct LoginView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: LoginViewModel

    // MARK: - Init -

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            form
            Spacer()
        }
        .padding(AppSpacing.expandedScreen)
        .background(AppColors.background)
        .navigationTitle(L10n.string("auth.login.title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.string("app.name"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)

            Text(L10n.string("auth.login.subtitle"))
                .font(.headline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.top, 32)
    }

    private var form: some View {
        VStack(spacing: 16) {
            TextField(L10n.string("auth.field.email"), text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .appInputField()

            SecureField(L10n.string("auth.field.password"), text: $viewModel.password)
                .textContentType(.password)
                .appInputField()

            if let errorMessage = viewModel.state.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            PrimaryButtonView(title: viewModel.buttonTitle) {
                Task {
                    await viewModel.login()
                }
            }
            .disabled(viewModel.state.isLoading)

            // TODO: Remove this temporary dev login button before release.
            Button("Dev Login") {
                Task {
                    await viewModel.loginWithTemporaryCredentials()
                }
            }
            .font(.headline)
            .appSecondaryButton()
            .disabled(viewModel.state.isLoading)

            Button(L10n.string("auth.login.createAccount")) {
                viewModel.openRegistration()
            }
            .appSecondaryButton()
        }
    }
}

#Preview {
    LoginView(
        viewModel: LoginViewModel(
            session: AppDependenciesAssembler.assemble().session,
            output: { _ in }
        )
    )
}
