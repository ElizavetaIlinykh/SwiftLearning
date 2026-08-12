import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    private let profileManager: ProfileManager
    private var cancellables: Set<AnyCancellable> = []

    var state: ProfileLoadingState {
        profileManager.state
    }

    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
        bindProfileManagerUpdates()
    }

    func loadProfile() async {
        await profileManager.loadProfile()
    }

    private func bindProfileManagerUpdates() {
        profileManager.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
