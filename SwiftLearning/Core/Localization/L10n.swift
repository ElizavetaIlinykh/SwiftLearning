import Foundation

private final class L10nBundleToken {}

enum L10n {
    private static let fallbackBundle = Bundle(for: L10nBundleToken.self)
    private static var language: AppLanguage = .defaultLanguage

    static func setLanguage(_ language: AppLanguage) {
        self.language = language
    }

    static func string(_ key: String) -> String {
        localizedBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(
            format: string(key),
            locale: Locale(identifier: language.rawValue),
            arguments: arguments
        )
    }

    private static var localizedBundle: Bundle {
        guard let path = fallbackBundle.path(forResource: language.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path)
        else {
            return fallbackBundle
        }

        return bundle
    }
}
