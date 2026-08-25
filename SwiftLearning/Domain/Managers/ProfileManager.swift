import Foundation

struct ProfileContent: Equatable {
    // MARK: - Public properties -

    let user: UserProfile
    let statistics: UserStatistics
}

typealias ProfileLoadingState = LoadingState<ProfileContent>

/// Loads profile data required by the profile screen.
///
/// The manager coordinates profile and statistics requests, but does not own UI state.
@MainActor
final class ProfileManager {
    // MARK: - Private properties -

    private let userService: UserServicing
    private var currentTask: Task<ProfileContent, Error>?

    // MARK: - Init -

    /// Creates a profile manager.
    ///
    /// - Parameter userService: Service used to fetch profile content.
    init(userService: UserServicing) {
        self.userService = userService
    }

    // MARK: - Public methods -

    /// Loads user profile and statistics, sharing an in-flight request when one is already running.
    ///
    /// - Returns: Combined profile content.
    func loadProfile() async throws -> ProfileContent {
        if let currentTask {
            return try await currentTask.value
        }

        let task = Task { @MainActor in
            async let user = userService.fetchUser()
            async let statistics = userService.fetchStatistics()

            return try await ProfileContent(
                user: user,
                statistics: statistics
            )
        }
        currentTask = task

        defer {
            currentTask = nil
        }

        return try await task.value
    }
}
