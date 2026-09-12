import SwiftUI

enum AppSpacing {
    static let xSmall: CGFloat = 6
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 14
    static let card: CGFloat = 16
    static let section: CGFloat = 20
    static let screen: CGFloat = 20
    static let expandedScreen: CGFloat = 24
}

enum AppRadius {
    static let field: CGFloat = 12
    static let control: CGFloat = 14
    static let card: CGFloat = 16
    static let largeCard: CGFloat = 18
}

enum AppOpacity {
    static let subtleFill: Double = 0.08
    static let tintFill: Double = 0.12
    static let selectedFill: Double = 0.13
    static let hairlineBorder: Double = 0.06
    static let secondaryBorder: Double = 0.12
    static let activeBorder: Double = 0.55
}

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

struct AppCardStyle: ViewModifier {
    let background: Color
    let borderColor: Color
    let radius: CGFloat
    let padding: CGFloat
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}

struct AppProgressBarView: View {
    let value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppColors.progressTrack)

                Capsule()
                    .fill(AppColors.progressFill)
                    .frame(width: geometry.size.width * min(max(value, 0), 1))
            }
        }
        .frame(height: 8)
    }
}

struct AppSecondaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(AppColors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(AppColors.buttonSecondary)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous)
                    .stroke(AppColors.border, lineWidth: 1)
            )
    }
}

extension View {
    func appCard(
        background: Color = AppColors.card,
        borderColor: Color = AppColors.border,
        radius: CGFloat = AppRadius.card,
        padding: CGFloat = AppSpacing.card,
        lineWidth: CGFloat = 1
    ) -> some View {
        modifier(
            AppCardStyle(
                background: background,
                borderColor: borderColor,
                radius: radius,
                padding: padding,
                lineWidth: lineWidth
            )
        )
    }

    func appRoundedBackground(
        _ color: Color,
        radius: CGFloat = AppRadius.control
    ) -> some View {
        background(color)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }

    func appInputField(
        borderColor: Color = AppColors.border,
        lineWidth: CGFloat = 1
    ) -> some View {
        padding(AppSpacing.large)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }

    func appSecondaryButton() -> some View {
        modifier(AppSecondaryButtonStyle())
    }
}
