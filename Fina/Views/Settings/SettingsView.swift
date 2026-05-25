import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM:        AuthViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @State private var currencyInput  = ""
    @State private var showClearAlert = false

    var body: some View {
        NavigationStack {
            Form {
                // Currency
                Section("Currency") {
                    TextField("Symbol (e.g. PHP, $, €)", text: $currencyInput)
                        .onAppear { currencyInput = transactionVM.settings.currencySymbol }
                        .onSubmit { saveSettings() }
                }

                // Appearance
                Section("Appearance") {
                    Picker("Theme", selection: Binding(
                        get: { transactionVM.settings.themeMode },
                        set: { newMode in
                            Task {
                                await transactionVM.updateSettings(
                                    userId: authVM.currentUser?.uid ?? "",
                                    updated: transactionVM.settings.copyWith(themeMode: newMode)
                                )
                            }
                        }
                    )) {
                        ForEach(AppThemeMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue.capitalized).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Account
                Section("Account") {
                    if let email = authVM.currentUser?.email {
                        LabeledContent("Signed in as", value: email)
                    }
                    Button(role: .destructive) { authVM.logout() } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }

                // Data
                Section("Data") {
                    NavigationLink("Manage Categories") {
                        CategoryListView()
                    }
                    Button(role: .destructive) { showClearAlert = true } label: {
                        Label("Clear All Data", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Clear All Data?", isPresented: $showClearAlert) {
                Button("Clear", role: .destructive) {
                    Task {
                        await transactionVM.clearAllData(userId: authVM.currentUser?.uid ?? "")
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will delete all transactions and reset categories. This cannot be undone.")
            }
        }
    }

    private func saveSettings() {
        Task {
            await transactionVM.updateSettings(
                userId: authVM.currentUser?.uid ?? "",
                updated: transactionVM.settings.copyWith(currencySymbol: currencyInput)
            )
        }
    }
}
