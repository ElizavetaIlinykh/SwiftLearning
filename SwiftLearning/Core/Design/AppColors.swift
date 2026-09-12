import SwiftUI

enum ColorPalette {
    static let primary = Color(hex: 0x10B981)
    static let primaryPressed = Color(hex: 0x059669)
    static let background = Color(hex: 0xF7FCFA)
    static let surface = Color(hex: 0xFFFFFF)
    static let card = Color(hex: 0xFFFFFF)
    static let border = Color(hex: 0xE5E7EB)
    static let textPrimary = Color(hex: 0x111827)
    static let textSecondary = Color(hex: 0x6B7280)
    static let success = Color(hex: 0x10B981)
    static let warning = Color(hex: 0xF59E0B)
    static let error = Color(hex: 0xEF4444)
    static let accent = Color(hex: 0x34D399)
    static let disabled = Color(hex: 0xD1D5DB)
}

enum AppColors {
    static let background = ColorPalette.background
    static let surface = ColorPalette.surface
    static let card = ColorPalette.card

    static let primary = ColorPalette.primary
    static let primaryPressed = ColorPalette.primaryPressed

    static let textPrimary = ColorPalette.textPrimary
    static let textSecondary = ColorPalette.textSecondary

    static let success = ColorPalette.success
    static let warning = ColorPalette.warning
    static let error = ColorPalette.error

    static let border = ColorPalette.border
    static let divider = ColorPalette.border

    static let buttonPrimary = ColorPalette.primary
    static let buttonSecondary = ColorPalette.surface
    static let buttonDisabled = ColorPalette.disabled

    static let lessonLocked = ColorPalette.disabled
    static let lessonCurrent = ColorPalette.primary
    static let lessonCompleted = ColorPalette.success

    static let progressTrack = ColorPalette.border
    static let progressFill = ColorPalette.primary

    static let accent = ColorPalette.accent
    static let onPrimary = ColorPalette.surface
    static let codeBackground = ColorPalette.textPrimary

    static let subtleFill = ColorPalette.textSecondary.opacity(AppOpacity.subtleFill)
    static let primaryFill = ColorPalette.primary.opacity(AppOpacity.tintFill)
    static let primarySelectedFill = ColorPalette.primary.opacity(AppOpacity.selectedFill)
    static let successFill = ColorPalette.success.opacity(AppOpacity.tintFill)
    static let warningFill = ColorPalette.warning.opacity(AppOpacity.tintFill)
    static let errorFill = ColorPalette.error.opacity(AppOpacity.tintFill)
    static let disabledFill = ColorPalette.disabled.opacity(AppOpacity.selectedFill)
}

private extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
