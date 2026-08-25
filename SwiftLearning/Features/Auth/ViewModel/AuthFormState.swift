import Foundation

enum AuthFormState: Equatable {
    case idle
    case loading
    case failed(String)

    var errorMessage: String? {
        guard case let .failed(message) = self else {
            return nil
        }

        return message
    }

    var isLoading: Bool {
        self == .loading
    }
}
