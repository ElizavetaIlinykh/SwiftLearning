import SwiftUI

struct RegisterView: View {
    // MARK: - Private properties -

    @StateObject private var viewModel: RegisterViewModel

    // MARK: - Init -

    init(viewModel: RegisterViewModel) {
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
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Register once and your progress will stay with your account.")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 32)
    }

    private var form: some View {
        VStack(spacing: 16) {
            TextField("Name", text: $viewModel.name)
                .textContentType(.name)
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            SecureField("Password", text: $viewModel.password)
                .textContentType(.newPassword)
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
                    await viewModel.register()
                }
            }
            .disabled(viewModel.state.isLoading)

            Button("Back to login") {
                viewModel.openLogin()
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    RegisterView(
        viewModel: RegisterViewModel(
            session: AppDependenciesAssembler.assemble().session,
            output: { _ in }
        )
    )
}
