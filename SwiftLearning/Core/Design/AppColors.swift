import SwiftUI
import UIKit

private struct DynamicColorPair {
    let light: UInt
    let dark: UInt
}

enum ColorPalette {
    static let background = dynamicColor(light: 0xF7FCFA, dark: 0x0F172A)
    static let surface = dynamicColor(light: 0xFFFFFF, dark: 0x1E293B)
    static let card = dynamicColor(light: 0xFFFFFF, dark: 0x273449)

    static let primary = dynamicColor(light: 0x10B981, dark: 0x34D399)
    static let primaryPressed = dynamicColor(light: 0x059669, dark: 0x10B981)
    static let accent = dynamicColor(light: 0x34D399, dark: 0x6EE7B7)

    static let border = dynamicColor(light: 0xE5E7EB, dark: 0x334155)
    static let divider = dynamicColor(light: 0xE5E7EB, dark: 0x475569)

    static let textPrimary = dynamicColor(light: 0x111827, dark: 0xF8FAFC)
    static let textSecondary = dynamicColor(light: 0x6B7280, dark: 0xCBD5E1)

    static let success = dynamicColor(light: 0x10B981, dark: 0x22C55E)
    static let warning = dynamicColor(light: 0xF59E0B, dark: 0xFBBF24)
    static let error = dynamicColor(light: 0xEF4444, dark: 0xF87171)

    static let disabled = dynamicColor(light: 0xD1D5DB, dark: 0x64748B)
    static let onPrimary = dynamicColor(light: 0x052E16, dark: 0x052E16)
    static let codeBackground = dynamicColor(light: 0x111827, dark: 0x020617)
    static let codeText = dynamicColor(light: 0xF8FAFC, dark: 0xE2E8F0)

    private static func dynamicColor(light: UInt, dark: UInt) -> Color {
        Color(
            uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
            }
        )
    }
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
    static let divider = ColorPalette.divider

    static let buttonPrimary = ColorPalette.primary
    static let buttonSecondary = ColorPalette.surface
    static let buttonDisabled = ColorPalette.disabled

    static let lessonLocked = ColorPalette.disabled
    static let lessonCurrent = ColorPalette.primary
    static let lessonCompleted = ColorPalette.success

    static let progressTrack = ColorPalette.border
    static let progressFill = ColorPalette.primary

    static let accent = ColorPalette.accent
    static let onPrimary = ColorPalette.onPrimary
    static let codeBackground = ColorPalette.codeBackground
    static let codeText = ColorPalette.codeText

    static let subtleFill = ColorPalette.textSecondary.opacity(AppOpacity.subtleFill)
    static let primaryFill = ColorPalette.primary.opacity(AppOpacity.tintFill)
    static let primarySelectedFill = ColorPalette.primary.opacity(AppOpacity.selectedFill)
    static let successFill = ColorPalette.success.opacity(AppOpacity.tintFill)
    static let warningFill = ColorPalette.warning.opacity(AppOpacity.tintFill)
    static let errorFill = ColorPalette.error.opacity(AppOpacity.tintFill)
    static let disabledFill = ColorPalette.disabled.opacity(AppOpacity.selectedFill)
}

private extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
}
