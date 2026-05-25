import SwiftUI

struct TransactionRow: View {
    let transaction:    Transaction
    let category:       Category?
    let currencySymbol: String

    var body: some View {
        HStack(spacing: 12) {
            CategoryIcon(icon: category?.icon ?? "questionmark")
            VStack(alignment: .leading, spacing: 2) {
                Text(category?.name ?? "Unknown")
                    .font(.subheadline).fontWeight(.medium)
                if let note = transaction.note, !note.isEmpty {
                    Text(note).font(.caption).foregroundColor(.secondary)
                }
                Text(transaction.date, style: .date)
                    .font(.caption2).foregroundColor(.secondary)
            }
            Spacer()
            AmountText(amount: transaction.amount, type: transaction.type,
                       currencySymbol: currencySymbol)
        }
        .padding(.vertical, 4)
    }
}
