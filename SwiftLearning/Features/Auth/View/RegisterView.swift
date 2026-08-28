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
        .navigationTitle(L10n.string("auth.register.navigationTitle"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.string("auth.register.title"))
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(L10n.string("auth.register.subtitle"))
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 32)
    }

    private var form: some View {
        VStack(spacing: 16) {
            TextField(L10n.string("auth.field.name"), text: $viewModel.name)
                .textContentType(.name)
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            TextField(L10n.string("auth.field.email"), text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            SecureField(L10n.string("auth.field.password"), text: $viewModel.password)
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

            Button(L10n.string("auth.register.backToLogin")) {
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
