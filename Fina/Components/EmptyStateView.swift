import SwiftUI

struct EmptyStateView: View {
    let message: String
    var icon: String = "tray.fill"

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 72, height: 72)
                
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            
            Text(message)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}
