import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String {
        rawValue
    }

    var localizedTitleKey: String {
        switch self {
        case .system:
            "profile.theme.system"
        case .light:
            "profile.theme.light"
        case .dark:
            "profile.theme.dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            nil
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}
