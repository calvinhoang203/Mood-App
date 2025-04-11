//
//  LoginWithEmailView.swift
//  Mental Health
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


enum AuthNavigation: Hashable {
    case profile
}

struct LoginWithEmailView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var goToSignUp = false
    @State private var goToLogin = false
    @State private var navSelection: AuthNavigation? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Spacer(minLength: 40)

                        Image("loginIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        Text("Login with Email")
                            .font(.custom("Alexandria", size: 24))
                            .foregroundColor(.black)

                        customTextField(title: "Email *", text: $email)
                        customSecureField(title: "Password *", text: $password)

                        Button(action: {
                            userLogin()
                        }) {
                            Image("LoginButton")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
                        }
                        .padding(.top, 10)

                        Button(action: {
                            sendPasswordReset()
                        }) {
                            Text("Forgot Password?")
                                .font(.custom("Alexandria", size: 16))
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 5)

                        Button(action: {
                            goToSignUp = true
                        }) {
                            Text("Don't have an account? Sign Up")
                                .font(.custom("Alexandria", size: 16))
                                .foregroundColor(.blue)
                                .padding(.top, 10)
                        }

                        Button(action: {
                            goToLogin = true
                        }) {
                            Text("Try another login method?")
                                .font(.custom("Alexandria", size: 16))
                                .foregroundColor(.blue)
                                .padding(.top, 10)
                        }

                        
                        NavigationLink(
                            destination: ProfileView(),
                            tag: AuthNavigation.profile,
                            selection: $navSelection
                        ) {
                            EmptyView()
                        }
                        .hidden()

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationDestination(isPresented: $goToSignUp) {
                SignUpView()
            }
            .navigationDestination(isPresented: $goToLogin) {
                LoginView()
            }
            .alert("Notice", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "An unknown error occurred.")
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func userLogin() {
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

        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            showAlert = true
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                errorMessage = "No account found. Either your email or password is incorrect."
                showAlert = true
            } else if (result?.user) != nil {
                let db = Firestore.firestore()

                db.collection("Users' info").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
                    if let error = error {
                        print("⚠️ Error fetching user data: \(error.localizedDescription)")
                        errorMessage = "Failed to retrieve your user info."
                        showAlert = true
                        return
                    }

                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        print("❌ No user document found for email \(email)")
                        errorMessage = "No user profile found. Please sign up."
                        showAlert = true
                        return
                    }

                    DispatchQueue.main.async {
                        navSelection = .profile
                    }
                }
            }
        }
    }

    func sendPasswordReset() {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !email.isEmpty else {
            errorMessage = "Please enter your email above first."
            showAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "Password reset email sent!"
            }
            showAlert = true
        }
    }
}

struct LoginWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        LoginWithEmailView()
    }
}
