import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    private let profileManager: ProfileManager
    private let session: SessionState
    private var cancellables: Set<AnyCancellable> = []

    var state: ProfileLoadingState {
        profileManager.state
    }

    init(
        profileManager: ProfileManager,
        session: SessionState
    ) {
        self.profileManager = profileManager
        self.session = session
        bindProfileManagerUpdates()
    }

    func loadProfile() async {
        await profileManager.loadProfile()
    }

    func logout() {
        session.logout()
    }

    private func bindProfileManagerUpdates() {
        profileManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
