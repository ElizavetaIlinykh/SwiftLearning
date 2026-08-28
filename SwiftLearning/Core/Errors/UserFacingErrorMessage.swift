import Foundation

enum UserFacingErrorMessage {
    // MARK: - Public methods -

    static func message(
        for error: Error,
        fallback: String = L10n.string("error.generic")
    ) -> String {
        if let authError = error as? AuthError {
            return authError.localizedDescription
        }

        if let networkError = error as? NetworkManager.NetworkError {
            return message(for: networkError)
        }

        if let urlError = error as? URLError {
            return message(for: urlError)
        }

        return fallback
    }

    // MARK: - Private methods -

    private static func message(for error: NetworkManager.NetworkError) -> String {
        switch error {
        case .invalidURL:
            L10n.string("error.invalidURL")
        case .invalidResponse:
            L10n.string("error.invalidResponse")
        case let .serverError(statusCode, _):
            message(forStatusCode: statusCode)
        case .decodingFailed:
            L10n.string("error.decodingFailed")
        }
    }

    private static func message(forStatusCode statusCode: Int) -> String {
        switch statusCode {
        case 401:
            L10n.string("auth.error.unauthorized")
        case 403:
            L10n.string("error.forbidden")
        case 404:
            L10n.string("error.notFound")
        case 409:
            L10n.string("error.conflict")
        case 422:
            L10n.string("error.validation")
        case 500 ... 599:
            L10n.string("error.serverUnavailable")
        default:
            L10n.string("auth.error.requestFailed")
        }
    }

    private static func message(for error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            L10n.string("error.networkOffline")
        case .timedOut:
            L10n.string("error.timeout")
        default:
            L10n.string("error.networkFailed")
        }
    }
}
