import SwiftUI

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
