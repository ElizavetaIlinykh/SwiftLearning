import SwiftUI

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

struct AppNavigationContainerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackground(AppColors.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .tint(AppColors.primary)
    }
}

struct AppTabContainerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackground(AppColors.surface, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .tint(AppColors.primary)
    }
}

struct AppSettingsFormStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(AppColors.background)
            .tint(AppColors.primary)
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
            .foregroundStyle(AppColors.textPrimary)
            .tint(AppColors.primary)
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

    func appNavigationContainer() -> some View {
        modifier(AppNavigationContainerStyle())
    }

    func appTabContainer() -> some View {
        modifier(AppTabContainerStyle())
    }

    func appSettingsForm() -> some View {
        modifier(AppSettingsFormStyle())
    }
}
