import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    // MARK: - Private properties -

    private let profileManager: ProfileManager
    private let session: SessionState
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init -

    @Published private(set) var state: ProfileLoadingState
    init(
        profileManager: ProfileManager,
        session: SessionState
    ) {
        self.profileManager = profileManager
        self.session = session
        state = profileManager.state

        bindProfileManager()
    }

    // MARK: - Public methods -

    func loadProfile() async {
        await profileManager.loadProfile()
    }

    func logout() {
        session.logout()
    }

    // MARK: - Private methods -

    private func bindProfileManager() {
        profileManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
