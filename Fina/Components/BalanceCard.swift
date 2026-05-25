import SwiftUI

struct BalanceCard: View {
    let balance:        Double
    let income:         Double
    let expense:        Double
    let currencySymbol: String

    var body: some View {
        VStack(spacing: 24) {
            // Top Section: Total Balance
            VStack(spacing: 8) {
                Text("Total Balance")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(currencySymbol)\(String(format: "%.2f", balance))")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Bottom Section: Income & Expense
            HStack(spacing: 0) {
                // Income
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "arrow.down")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Income")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(currencySymbol)\(String(format: "%.2f", income))")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundColor(.white)
                            .monospacedDigit()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Expense
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "arrow.up")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Expense")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(currencySymbol)\(String(format: "%.2f", expense))")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundColor(.white)
                            .monospacedDigit()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [AppColors.primary, AppColors.primary.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: AppColors.primary.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}
