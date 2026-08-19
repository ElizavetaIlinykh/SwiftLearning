import SwiftUI

struct RegisterView: View {
    // MARK: - Public properties -

    @ObservedObject var session: SessionState

    let onLoginTapped: () -> Void

    // MARK: - Private properties -

    @State private var name = ""
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
            TextField("Name", text: $name)
                .textContentType(.name)
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            if let errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            PrimaryButton(title: isLoading ? "Creating..." : "Register") {
                Task {
                    await register()
                }
            }
            .disabled(isLoading)

            Button("Back to login", action: onLoginTapped)
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Private methods -

    private func register() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            try await session.register(name: name, email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    RegisterView(
        session: AppDependenciesAssembler.assemble().session,
        onLoginTapped: {}
    )
}
