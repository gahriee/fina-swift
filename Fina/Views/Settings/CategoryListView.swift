import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject var authVM:        AuthViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel

    @State private var showAddForm = false
    @State private var newName   = ""
    @State private var newIcon   = "tag.fill"
    @State private var newType:    TransactionType = .expense
    @State private var errorMsg: String?

    var body: some View {
        List {
            ForEach(transactionVM.categories) { cat in
                HStack(spacing: 16) {
                    CategoryIcon(icon: cat.icon)
                    
                    Text(cat.name)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(cat.type.label.uppercased())
                        .font(.system(.caption2, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(cat.type.color.opacity(0.15))
                        .foregroundColor(cat.type.color)
                        .clipShape(Capsule())
                }
                .padding(.vertical, 4)
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
        .listStyle(.inset)
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showAddForm = true } label: { 
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showAddForm) {
            addCategorySheet
        }
        .alert("Cannot delete", isPresented: .constant(errorMsg != nil), actions: {
            Button("OK") { errorMsg = nil }
        }, message: { Text(errorMsg ?? "") })
    }
    
    @ViewBuilder
    private var addCategorySheet: some View {
        VStack(spacing: 24) {
            Text("New Category")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name").font(.caption).foregroundColor(.secondary)
                    TextField("Groceries, Salary, etc.", text: $newName)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("SF Symbol Name").font(.caption).foregroundColor(.secondary)
                    TextField("tag.fill", text: $newIcon)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Type").font(.caption).foregroundColor(.secondary)
                    Picker("Type", selection: $newType) {
                        ForEach(TransactionType.allCases, id: \.self) { t in
                            Text(t.label).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            HStack(spacing: 16) {
                Button(action: { showAddForm = false }) {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.secondary.opacity(0.1))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    Task {
                        await transactionVM.addCategory(
                            userId: authVM.currentUser?.uid ?? "",
                            name: newName, icon: newIcon, type: newType
                        )
                        showAddForm = false
                    }
                }) {
                    Text("Add")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(newName.isEmpty ? AppColors.primary.opacity(0.5) : AppColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .disabled(newName.isEmpty)
            }
        }
        .padding(32)
        .frame(maxWidth: 360)
        .background(.regularMaterial)
    }
}
