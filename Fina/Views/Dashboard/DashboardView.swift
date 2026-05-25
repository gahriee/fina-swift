import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var authVM:        AuthViewModel
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Balance card
                    BalanceCard(
                        balance:        transactionVM.balance,
                        income:         transactionVM.totalIncome,
                        expense:        transactionVM.totalExpense,
                        currencySymbol: transactionVM.settings.currencySymbol
                    )

                    recentTransactionsSection
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView(userId: authVM.currentUser?.uid ?? "")
            }
        }
    }

    @ViewBuilder
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent").font(.headline)
            if transactionVM.recentTransactions.isEmpty {
                EmptyStateView(message: "No transactions yet")
            } else {
                ForEach(transactionVM.recentTransactions) { tx in
                    TransactionRow(
                        transaction:    tx,
                        category:       transactionVM.categories.first { $0.id == tx.categoryId },
                        currencySymbol: transactionVM.settings.currencySymbol
                    )
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(16)
    }
}
