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

enum AppColors {
    static let screenBackground = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemGroupedBackground)
    static let hairlineBorder = Color.primary.opacity(AppOpacity.hairlineBorder)
    static let secondaryFill = Color.secondary.opacity(AppOpacity.subtleFill)
    static let secondaryBorder = Color.secondary.opacity(AppOpacity.secondaryBorder)
    static let accentFill = Color.accentColor.opacity(AppOpacity.tintFill)
    static let accentSelectedFill = Color.accentColor.opacity(AppOpacity.selectedFill)
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

extension View {
    func appCard(
        background: Color = AppColors.cardBackground,
        borderColor: Color = AppColors.hairlineBorder,
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
        borderColor: Color = .clear,
        lineWidth: CGFloat = 0
    ) -> some View {
        padding(AppSpacing.large)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.field, style: .continuous)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}
