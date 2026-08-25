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
        .padding(24)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Swift Learning")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Sign in to continue learning Swift.")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 32)
    }

    private var form: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            if let errorMessage = viewModel.state.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            PrimaryButtonView(title: viewModel.buttonTitle) {
                Task {
                    await viewModel.login()
                }
            }
            .disabled(viewModel.state.isLoading)

            Button("Create an account") {
                viewModel.openRegistration()
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
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
