//
//  SignUpView.swift
//  Mental Health
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

let db = Firestore.firestore()

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showAlert = false

    @State private var goToGetProfile = false
    @State private var goToLogin = false
    @State private var isPasswordVisible = false


    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Image("loginIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)

                    Text("Create an Account")
                        .font(.custom("Alexandria", size: 24))
                        .foregroundColor(.black)

                    customTextField(title: "Email *", text: $email)
                    customSecureField(title: "Password *", text: $password)

                    // Sign Up Button
                    Button(action: {
                        userSignUp()
                    }) {
                        Image("SignUpButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
                    }
                    .padding(.top, 10)

                    // Navigation triggers via buttons
                    Button(action: {
                        goToLogin = true
                    }) {
                        Text("Already have an account? Log in")
                            .font(.custom("Alexandria", size: 16))
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
            }

            // Navigation destinations
            .navigationDestination(isPresented: $goToGetProfile) {
                GetProfileView()
            }
            .navigationDestination(isPresented: $goToLogin) {
                LoginWithEmailView()
            }

            // Alert
            .alert("Sign Up Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Something went wrong.")
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func userSignUp() {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !email.isEmpty else {
            errorMessage = "Please enter your email."
            showAlert = true
            return
        }

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        guard emailPredicate.evaluate(with: email) else {
            errorMessage = "Please enter a valid email address."
            showAlert = true
            return
        }

        if let passwordError = passwordValidationError(password) {
            errorMessage = passwordError
            showAlert = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showAlert = true
            } else {
                goToGetProfile = true
            }
        }
    }

    func passwordValidationError(_ password: String) -> String? {
        if password.count < 8 {
            return "Password must be at least 8 characters long."
        }

        let uppercase = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
        if !uppercase {
            return "Password must include at least one uppercase letter."
        }

        let lowercase = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
        if !lowercase {
            return "Password must include at least one lowercase letter."
        }

        let number = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
        if !number {
            return "Password must include at least one number."
        }

        let special = NSPredicate(format: "SELF MATCHES %@", ".*[!@#\\?\\]]+.*").evaluate(with: password)
        if !special {
            return "Password must include at least one special character (! @ # ? ])."
        }

        return nil
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

