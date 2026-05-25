import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var authVM:        AuthViewModel
    @State private var filter:       TransactionFilter = .all
    @State private var showAddSheet  = false
    @State private var editingTx:    Transaction?

    enum TransactionFilter: String, CaseIterable {
        case all = "All", income = "Income", expense = "Expense"
    }

    private var filtered: [Transaction] {
        switch filter {
        case .all:     return transactionVM.transactions
        case .income:  return transactionVM.transactions.filter { $0.type == .income }
        case .expense: return transactionVM.transactions.filter { $0.type == .expense }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.secondary.opacity(0.03)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Picker("Filter", selection: $filter) {
                        ForEach(TransactionFilter.allCases, id: \.self) { f in
                            Text(f.rawValue).tag(f)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .background(.regularMaterial)
                    
                    if filtered.isEmpty {
                        Spacer()
                        EmptyStateView(message: "No transactions found", icon: "doc.text.magnifyingglass")
                        Spacer()
                    } else {
                        List {
                            ForEach(filtered) { tx in
                                TransactionRow(
                                    transaction:    tx,
                                    category:       transactionVM.categories.first { $0.id == tx.categoryId },
                                    currencySymbol: transactionVM.settings.currencySymbol
                                )
                                .padding(.vertical, 4)
                                .onTapGesture { editingTx = tx }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        Task { await transactionVM.deleteTransaction(id: tx.id) }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(.inset)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView(userId: authVM.currentUser?.uid ?? "")
            }
            .sheet(item: $editingTx) { tx in
                AddTransactionView(userId: authVM.currentUser?.uid ?? "", editing: tx)
            }
        }
    }
}
