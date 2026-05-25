import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject var authVM:        AuthViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel

    @State private var showAddForm = false
    @State private var newName   = ""
    @State private var newIcon   = "tag"
    @State private var newType:    TransactionType = .expense
    @State private var errorMsg: String?

    var body: some View {
        List {
            ForEach(transactionVM.categories) { cat in
                HStack {
                    CategoryIcon(icon: cat.icon)
                    Text(cat.name)
                    Spacer()
                    Text(cat.type.label)
                        .font(.caption)
                        .padding(.horizontal, 8).padding(.vertical, 2)
                        .background(cat.type.color.opacity(0.15))
                        .foregroundColor(cat.type.color)
                        .cornerRadius(6)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task {
                            let ok = await transactionVM.deleteCategory(id: cat.id)
                            if !ok { errorMsg = "Reassign or delete transactions first" }
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showAddForm = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showAddForm) {
            VStack(spacing: 16) {
                Text("New Category").font(.headline)
                TextField("Name", text: $newName)
                    .textFieldStyle(.roundedBorder)
                TextField("SF Symbol name", text: $newIcon)
                    .textFieldStyle(.roundedBorder)
                Picker("Type", selection: $newType) {
                    ForEach(TransactionType.allCases, id: \.self) { t in
                        Text(t.label).tag(t)
                    }
                }.pickerStyle(.segmented)
                HStack {
                    Button("Cancel") { showAddForm = false }
                    Spacer()
                    Button("Add") {
                        Task {
                            await transactionVM.addCategory(
                                userId: authVM.currentUser?.uid ?? "",
                                name: newName, icon: newIcon, type: newType
                            )
                            showAddForm = false
                        }
                    }
                    .buttonStyle(.borderedProminent).tint(AppColors.primary)
                    .disabled(newName.isEmpty)
                }
            }
            .padding()
            .frame(width: 300)
        }
        .alert("Cannot delete", isPresented: .constant(errorMsg != nil), actions: {
            Button("OK") { errorMsg = nil }
        }, message: { Text(errorMsg ?? "") })
    }
}
