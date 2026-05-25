import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @Environment(\.dismiss) private var dismiss

    let userId:  String
    var editing: Transaction? = nil   // nil = add mode, non-nil = edit mode

    @State private var amountText  = ""
    @State private var type:         TransactionType = .expense
    @State private var categoryId  = ""
    @State private var date        = Date()
    @State private var note        = ""

    private var filteredCategories: [Category] {
        transactionVM.categories.filter { $0.type == type }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") { dismiss() }
                Spacer()
                Text(editing == nil ? "Add Transaction" : "Edit Transaction")
                    .font(.headline)
                Spacer()
                Button {
                    Task { await save(); dismiss() }
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColors.primary)
                .disabled(amountText.isEmpty || categoryId.isEmpty)
            }
            .padding()

            Divider()

            Form {
                // Amount with currency prefix
                Section("Amount") {
                    HStack {
                        Text(transactionVM.settings.currencySymbol)
                            .foregroundColor(.secondary)
                        TextField("0.00", text: $amountText)
                    }
                }

                // Income / Expense toggle
                Section("Type") {
                    Picker("Type", selection: $type) {
                        ForEach(TransactionType.allCases, id: \.self) { t in
                            Text(t.label).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: type) { categoryId = "" }
                }

                // Category dropdown — filtered by type
                Section("Category") {
                    Picker("Category", selection: $categoryId) {
                        Text("Select…").tag("")
                        ForEach(filteredCategories) { cat in
                            Label(cat.name, systemImage: cat.icon).tag(cat.id)
                        }
                    }
                }

                // Date picker
                Section("Date") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }

                // Optional note
                Section("Note (optional)") {
                    TextField("Add a note…", text: $note)
                }
            }
        }
        .frame(width: 400, height: 480)
        .onAppear {
            if let tx = editing {
                amountText = String(format: "%.2f", tx.amount)
                type       = tx.type
                categoryId = tx.categoryId
                date       = tx.date
                note       = tx.note ?? ""
            }
        }
    }

    private func save() async {
        guard let amount = Double(amountText) else { return }
        if let tx = editing {
            await transactionVM.updateTransaction(
                Transaction(id: tx.id, userId: userId, amount: amount,
                            type: type, categoryId: categoryId, date: date,
                            note: note.isEmpty ? nil : note)
            )
        } else {
            await transactionVM.addTransaction(
                userId: userId, amount: amount, type: type,
                categoryId: categoryId, date: date, note: note.isEmpty ? nil : note
            )
        }
    }
}
