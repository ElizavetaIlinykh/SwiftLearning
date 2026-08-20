import Combine
import Foundation

struct ProfileContent: Equatable {
    // MARK: - Public properties -

    let user: UserProfile
    let statistics: UserStatistics
}

typealias ProfileLoadingState = LoadingState<ProfileContent>

@MainActor
final class ProfileManager: ObservableObject {
    // MARK: - Private properties -

    @Published private(set) var state: ProfileLoadingState = .idle
    private let userService: UserServicing

    // MARK: - Init -

    init(userService: UserServicing) {
        self.userService = userService
    }

    // MARK: - Public methods -

    func loadProfile() async {
        guard state != .loading else { return }

        state = .loading

        do {
            async let user = userService.fetchUser()
            async let statistics = userService.fetchStatistics()

            state = try await .loaded(
                ProfileContent(
                    user: user,
                    statistics: statistics
                )
            )
        } catch {
            state = .failed(UserFacingErrorMessage.message(for: error))
        }
    }
}
