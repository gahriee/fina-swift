import SwiftUI

struct CategoryIcon: View {
    let icon: String
    var size: CGFloat = 40

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.45, weight: .semibold))
            .frame(width: size, height: size)
            .background(AppColors.primary.opacity(0.12))
            .foregroundColor(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.3, style: .continuous))
    }
}
