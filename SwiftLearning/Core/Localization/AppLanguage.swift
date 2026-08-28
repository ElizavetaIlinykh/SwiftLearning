import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case russian = "ru"

    var id: String {
        rawValue
    }

    var localizedTitleKey: String {
        switch self {
        case .english:
            "profile.language.english"
        case .russian:
            "profile.language.russian"
        }
    }

    static var defaultLanguage: AppLanguage {
        let preferredIdentifier = Locale.preferredLanguages.first ?? Locale.current.identifier
        return preferredIdentifier.hasPrefix(russian.rawValue) ? .russian : .english
    }
}
