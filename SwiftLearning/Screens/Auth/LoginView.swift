import SwiftUI

struct LoginView: View {
    // MARK: - Public properties -

    @ObservedObject var session: SessionState

    let onRegisterTapped: () -> Void

    // MARK: - Private properties -

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

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
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            if let errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            PrimaryButton(title: isLoading ? "Signing In..." : "Login") {
                Task {
                    await login()
                }
            }
            .disabled(isLoading)

            Button("Create an account", action: onRegisterTapped)
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Private methods -

    private func login() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            try await session.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    LoginView(
        session: AppDependenciesAssembler.assemble().session,
        onRegisterTapped: {}
    )
}
