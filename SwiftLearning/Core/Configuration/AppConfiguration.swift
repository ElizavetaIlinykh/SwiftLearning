import Foundation

struct AppConfiguration {
    // MARK: - Private types -

    private enum Constants {
        static let baseURLKey = "API_BASE_URL"
        static let defaultBaseURLString = "http://127.0.0.1:8000"
    }

    // MARK: - Public properties -

    let baseURL: URL

    // MARK: - Public methods -

    static func load(
        bundle: Bundle = .main,
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) -> AppConfiguration {
        let baseURLString = environment[Constants.baseURLKey]
            ?? bundle.object(forInfoDictionaryKey: Constants.baseURLKey) as? String
            ?? Constants.defaultBaseURLString

        guard let baseURL = URL(string: baseURLString) else {
            preconditionFailure("Invalid API base URL: \(baseURLString)")
        }

        return AppConfiguration(baseURL: baseURL)
    }
}
