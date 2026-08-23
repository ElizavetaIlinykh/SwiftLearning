import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    // MARK: - Private properties -

    private let profileManager: ProfileManager
    private let session: SessionState

    // MARK: - Public properties -

    @Published private(set) var state: ProfileLoadingState = .idle

    // MARK: - Init -

    init(
        profileManager: ProfileManager,
        session: SessionState
    ) {
        self.profileManager = profileManager
        self.session = session
    }

    // MARK: - Public methods -

    func loadProfile() async {
        state = .loading

        do {
            let content = try await profileManager.loadProfile()
            state = .loaded(content)
        } catch is CancellationError {
            return
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }

    func logout() {
        session.logout()
    }
}
