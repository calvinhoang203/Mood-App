//
//  LoginView.swift
//  Mental Health
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import FirebaseFirestore


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    @State private var goToGetProfile = false
    @State private var goToProfile = false
    @Binding var isLoggedInBinding: Bool

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
                        .font(.custom("Alexandria", size: 24))
                        .foregroundColor(.black)

                    Text("Login to continue.")
                        .font(.custom("Alexandria", size: 18))
                        .foregroundColor(.black)

                    Button(action: { googleLogin() }) {
                        HStack {
                            Text("Continue with Google")
                                .font(.custom("Alexandrida", size: 16))
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
                                .font(.custom("Alexandrida", size: 16))
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
                        isLoggedIn = true
                    } else {
                        print("⚠️ Incomplete info. Going to GetProfileView.")
                        goToGetProfile = true
                    }
                }
            }
        }
    }

}



    
//    // MARK: - Apple Sign-In Flow
//    private func handleAppleSignIn() {
//        // 1) Generate random nonce
//        let nonce = randomNonceString()
//        appleSignInCoordinator.currentNonce = nonce
//        
//        // 2) Create the request
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        request.nonce = sha256(nonce)
//        
//        // 3) Create controller
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = appleSignInCoordinator
//        authorizationController.presentationContextProvider = appleSignInCoordinator
//        authorizationController.performRequests()
//    }
//    
//    // MARK: - Utility for Apple Sign-In
//    private func randomNonceString(length: Int = 32) -> String {
//        precondition(length > 0)
//        let charset: Array<Character> =
//            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//        
//        var result = ""
//        var remainingLength = length
//        
//        while remainingLength > 0 {
//            var randoms = [UInt8](repeating: 0, count: 16)
//            let errorCode = SecRandomCopyBytes(kSecRandomDefault, randoms.count, &randoms)
//            if errorCode != errSecSuccess {
//                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with error code \(errorCode)")
//            }
//            
//            randoms.forEach { random in
//                if remainingLength == 0 {
//                    return
//                }
//                if random < charset.count {
//                    result.append(charset[Int(random)])
//                    remainingLength -= 1
//                }
//            }
//        }
//        return result
//    }
//    
//    private func sha256(_ input: String) -> String {
//        let inputData = Data(input.utf8)
//        let hashed = SHA256.hash(data: inputData)
//        return hashed.compactMap {
//            String(format: "%02x", $0)
//        }.joined()
//    }
//    
//    func userLogout() {
//        if GIDSignIn.sharedInstance.hasPreviousSignIn(){
//            GIDSignIn.sharedInstance.signOut()
//            isLoggedIn = false
//            print("User logged out sucessfully.")
//            return
//        }
//        do {
//            try Auth.auth().signOut()
//            isLoggedIn = false
//            print("User logged out successfully.")
//        } catch let signOutError {
//            print("Error signing out: \(signOutError.localizedDescription)")
//        }
//    }
//}
//
//#Preview{
//    LoginView()
//}
//
//// MARK: - AppleSignInCoordinator
//class AppleSignInCoordinator: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//    
//    // This will store our random nonce
//    var currentNonce: String?
//    
//    // Published property to notify the LoginView
//    @Published var didSignInSuccessfully: Bool = false
//    
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first else {
//            return ASPresentationAnchor()
//        }
//        return window
//    }
//    
//    func authorizationController(controller: ASAuthorizationController,
//                                 didCompleteWithAuthorization authorization: ASAuthorization) {
//        
//        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//            print("Unable to retrieve AppleIDCredential")
//            didSignInSuccessfully = false
//            return
//        }
//        
//        guard let nonce = currentNonce else {
//            fatalError("Invalid state: A login callback was received, but no login request was sent.")
//        }
//        
//        guard let appleIDToken = appleIDCredential.identityToken,
//              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//            print("Unable to fetch/serialize identity token")
//            didSignInSuccessfully = false
//            return
//        }
//        
//        // 1) Create an OAuthProvider for Apple
//        let provider = OAuthProvider(providerID: "apple.com")
//
//        // 2) Get a credential from the provider
//        let credential = OAuthProvider.credential(withProviderID: idTokenString, accessToken: nonce)
//
//        // 3) Sign in with Firebase
//        Auth.auth().signIn(with: credential) { authResult, error in
//            if let error = error {
//                print("Error authenticating with Apple: \(error.localizedDescription)")
//                return
//            }
//            print("Successfully signed in with Apple & Firebase!")
//            // e.g., isLoggedIn = true
//        }
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Sign in with Apple failed: \(error.localizedDescription)")
//        didSignInSuccessfully = false
//    }




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedInBinding: .constant(false))
    }
}

