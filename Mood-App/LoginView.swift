//
//  LoginView.swift
//  Mental Health
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var goToGetProfile = false
    @State private var goToProfile = false
    @Binding var isLoggedInBinding: Bool
    @EnvironmentObject var storeData: StoreData

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

                    Text("Hey! Welcome to Moo'd.")
                        .font(.custom("Alexandria-Regular", size: 24))
                        .foregroundColor(.black)

                    Text("Login to continue.")
                        .font(.custom("Alexandria-Regular", size: 18))
                        .foregroundColor(.black)

                    Button(action: { googleLogin() }) {
                        HStack {
                            Text("Continue with Google")
                                .font(.custom("Alexandria-Regular", size: 16))
                            Image("googleIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)

                    NavigationLink(destination: LoginWithEmailView(isLoggedInBinding: $isLoggedInBinding)) {
                        HStack {
                            Text("Continue with Email")
                                .font(.custom("Alexandria-Regular", size: 16))
                            Image(systemName: "envelope")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)

                    Spacer()
                }
            }
            .navigationDestination(isPresented: $goToGetProfile) {
                GetProfileView()
            }
            .navigationDestination(isPresented: $goToProfile) {
                HomeView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func googleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }

            guard let signInResult = signInResult else { return }
            let user = signInResult.user
            guard let idToken = user.idToken?.tokenString else { return }
            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign in error: \(error.localizedDescription)")
                    return
                }

                guard let firebaseUser = authResult?.user else { return }
                let uid = firebaseUser.uid

                let db = Firestore.firestore()
                let userDocRef = db.collection("Users' info").document(uid)

                userDocRef.getDocument { document, error in
                    if let error = error {
                        print("❌ Error checking user info: \(error.localizedDescription)")
                        return
                    }

                    guard let doc = document, doc.exists, let data = doc.data() else {
                        print("🔸 No document found. Going to GetProfileView.")
                        goToGetProfile = true
                        return
                    }

                    let hasFirst = (data["firstName"] as? String)?.isEmpty == false
                    let hasLast = (data["lastName"] as? String)?.isEmpty == false
                    let hasPhone = (data["phoneNumber"] as? String)?.isEmpty == false

                    if hasFirst && hasLast && hasPhone {
                        print("✅ Profile complete. Going to ProfileView.")
                        goToProfile = true
                        isLoggedInBinding = true
                        storeData.loadUserDataFromFirestore()
                    } else {
                        print("⚠️ Incomplete info. Going to GetProfileView.")
                        goToGetProfile = true
                    }
                }
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedInBinding: .constant(false))
    }
}

