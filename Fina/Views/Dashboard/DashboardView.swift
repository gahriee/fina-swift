import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var authVM:        AuthViewModel
    @State private var showAddSheet = false
    @State private var editingTx:   Transaction?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.secondary.opacity(0.03)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Balance card
                        BalanceCard(
                            balance:        transactionVM.balance,
                            income:         transactionVM.totalIncome,
                            expense:        transactionVM.totalExpense,
                            currencySymbol: transactionVM.settings.currencySymbol
                        )
                        .padding(.top, 8)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)

                        recentTransactionsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Dashboard")
            .overlay(alignment: .bottomTrailing) {
                Button { showAddSheet = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(16)
                        .background(AppColors.primary)
                        .clipShape(Circle())
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(.plain)
                .padding(24)
            }
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView(userId: authVM.currentUser?.uid ?? "")
                    #if os(iOS)
                    .presentationDetents([.fraction(0.75), .large])
                    #endif
            }
            .sheet(item: $editingTx) { tx in
                AddTransactionView(userId: authVM.currentUser?.uid ?? "", editing: tx)
                    #if os(iOS)
                    .presentationDetents([.fraction(0.75), .large])
                    #endif
            }
        }
    }

    @ViewBuilder
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Transactions")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                if transactionVM.recentTransactions.isEmpty {
                    EmptyStateView(message: "No transactions yet")
                        .padding(.vertical, 32)
                } else {
                    ForEach(Array(transactionVM.recentTransactions.enumerated()), id: \.element.id) { index, tx in
                        TransactionRow(
                            transaction:    tx,
                            category:       transactionVM.categories.first { $0.id == tx.categoryId },
                            currencySymbol: transactionVM.settings.currencySymbol
                        )
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .contentShape(Rectangle())
                        .onTapGesture { editingTx = tx }
                        
                        if index < transactionVM.recentTransactions.count - 1 {
                            Divider()
                                .padding(.leading, 64)
                        }
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.regularMaterial)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
        }
    }
}
