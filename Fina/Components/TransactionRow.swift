import SwiftUI

struct TransactionRow: View {
    let transaction:    Transaction
    let category:       Category?
    let currencySymbol: String

    var body: some View {
        HStack(spacing: 16) {
            CategoryIcon(icon: category?.icon ?? "questionmark.circle", size: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category?.name ?? "Unknown")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.semibold)
                
                if let note = transaction.note, !note.isEmpty {
                    Text(note)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.8))
            }
            
            Spacer()
            
            AmountText(amount: transaction.amount, type: transaction.type,
                       currencySymbol: currencySymbol, font: .system(.headline, design: .rounded))
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
