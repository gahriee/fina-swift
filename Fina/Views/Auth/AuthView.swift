import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email    = ""
    @State private var password = ""
    @State private var isLogin  = true  // toggles between Login and Register

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.circle")
                .font(.system(size: 64))
                .foregroundColor(AppColors.primary)

            Text(isLogin ? "Sign In" : "Create Account")
                .font(.title2).fontWeight(.semibold)

            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }

            if let error = authVM.error {
                Text(error).foregroundColor(.red).font(.caption)
            }

            Button(isLogin ? "Sign In" : "Create Account") {
                Task {
                    if isLogin {
                        await authVM.login(email: email, password: password)
                    } else {
                        await authVM.register(email: email, password: password)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(AppColors.primary)
            .disabled(authVM.isLoading)

            if authVM.isLoading { ProgressView() }

            Button(isLogin ? "Don't have an account? Register" : "Already have an account? Sign in") {
                isLogin.toggle()
                authVM.error = nil
            }
            .buttonStyle(.plain)
            .foregroundColor(AppColors.primary)
        }
        .padding(40)
        .frame(width: 360)
    }
}
