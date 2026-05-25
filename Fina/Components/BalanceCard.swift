import SwiftUI

struct BalanceCard: View {
    let balance:        Double
    let income:         Double
    let expense:        Double
    let currencySymbol: String

    var body: some View {
        VStack(spacing: 12) {
            Text("Total Balance")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Text("\(currencySymbol)\(String(format: "%.2f", balance))")
                .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                .monospacedDigit()

            HStack(spacing: 24) {
                VStack(alignment: .leading) {
                    Label("Income", systemImage: "arrow.down.circle.fill")
                        .font(.caption).foregroundColor(.white.opacity(0.8))
                    Text("\(currencySymbol)\(String(format: "%.2f", income))")
                        .font(.subheadline).fontWeight(.semibold).foregroundColor(.white)
                        .monospacedDigit()
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Label("Expense", systemImage: "arrow.up.circle.fill")
                        .font(.caption).foregroundColor(.white.opacity(0.8))
                    Text("\(currencySymbol)\(String(format: "%.2f", expense))")
                        .font(.subheadline).fontWeight(.semibold).foregroundColor(.white)
                        .monospacedDigit()
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.primary)
        .cornerRadius(16)
    }
}
