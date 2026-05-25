import SwiftUI

struct CategoryIcon: View {
    let icon: String
    var size: CGFloat = 32

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.5))
            .frame(width: size, height: size)
            .background(AppColors.primary.opacity(0.12))
            .foregroundColor(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
