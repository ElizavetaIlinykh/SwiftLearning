import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    private let profileManager: ProfileManager
    private let session: SessionState
    private var cancellables: Set<AnyCancellable> = []

    @Published private(set) var state: ProfileLoadingState

    init(
        profileManager: ProfileManager,
        session: SessionState
    ) {
        self.profileManager = profileManager
        self.session = session
        self.state = profileManager.state

        bindProfileManager()
    }

    func loadProfile() async {
        await profileManager.loadProfile()
    }

    func logout() {
        session.logout()
    }

    private func bindProfileManager() {
        profileManager.$state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
