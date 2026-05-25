import SwiftUI
import Charts    // macOS 13+ built-in — replaces Flutter manual progress bars

struct ReportsView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @State private var selectedMonth = Date()

    private var totals: TransactionViewModel.MonthTotals {
        transactionVM.totals(for: selectedMonth)
    }
    private var breakdown: [(Category, Double)] {
        transactionVM.breakdown(for: selectedMonth)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Month navigator
                    HStack {
                        Button { stepMonth(-1) } label: {
                            Image(systemName: "chevron.left")
                        }
                        Text(selectedMonth, format: .dateTime.month(.wide).year())
                            .font(.headline)
                            .frame(minWidth: 160)
                        Button { stepMonth(1) } label: {
                            Image(systemName: "chevron.right")
                        }
                    }

                    // Totals strip
                    HStack(spacing: 24) {
                        VStack {
                            Text("Income").foregroundColor(.secondary).font(.caption)
                            AmountText(
                                amount: totals.income, type: .income,
                                currencySymbol: transactionVM.settings.currencySymbol
                            )
                        }
                        VStack {
                            Text("Expense").foregroundColor(.secondary).font(.caption)
                            AmountText(
                                amount: totals.expense, type: .expense,
                                currencySymbol: transactionVM.settings.currencySymbol
                            )
                        }
                    }

                    // Category breakdown with progress bars
                    if breakdown.isEmpty {
                        EmptyStateView(message: "No expenses this month")
                    } else {
                        ForEach(breakdown, id: \.0.id) { (cat, amount) in
                            HStack {
                                CategoryIcon(icon: cat.icon)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(cat.name).font(.subheadline)
                                    ProgressView(
                                        value: amount,
                                        total: max(totals.expense, 1)
                                    )
                                    .tint(AppColors.expense)
                                }
                                Spacer()
                                Text("\(transactionVM.settings.currencySymbol)\(String(format: "%.2f", amount))")
                                    .font(.subheadline).monospacedDigit()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Reports")
        }
    }

    private func stepMonth(_ delta: Int) {
        selectedMonth = Calendar.current.date(
            byAdding: .month, value: delta, to: selectedMonth
        ) ?? selectedMonth
    }
}
