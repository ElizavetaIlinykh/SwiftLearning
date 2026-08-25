import Combine
import Foundation

enum ProfileOutput {
    case logout
}

@MainActor
final class ProfileViewModel: ObservableObject {
    // MARK: - Private properties -

    private let profileManager: ProfileManager
    private let contentBuilder: ProfileContentBuilder
    private let output: (ProfileOutput) -> Void

    // MARK: - Public properties -

    @Published private(set) var state: ProfileViewState = .loading

    // MARK: - Init -

    init(
        profileManager: ProfileManager,
        contentBuilder: ProfileContentBuilder,
        output: @escaping (ProfileOutput) -> Void
    ) {
        self.profileManager = profileManager
        self.contentBuilder = contentBuilder
        self.output = output
    }

    // MARK: - Public methods -

    func loadProfile() async {
        state = .loading

        do {
            let content = try await profileManager.loadProfile()
            state = .content(contentBuilder.build(content: content))
        } catch is CancellationError {
            return
        } catch {
            state = .error(UserFacingErrorMessage.message(for: error))
        }
    }

    func logout() {
        output(.logout)
    }
}
