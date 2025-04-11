//
//  ProfileView.swift
//  Mental Health
//
//  
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreInternal

struct userProfile: Codable {
    let firebase_uid: String
    let email: String
    let name: String
}

struct ProfileView: View {
    @State private var userProfile: userProfile?
    
    var body: some View {
        VStack{
            if let profile = userProfile{
                Text("Hello \(profile.name)")
            } else {
                Text("Loading profile...")
                    .onAppear{
                        getProfile { profile in
                            self.userProfile = profile}
                    }
            }
        }
    }
    
    func getProfile(completion: @escaping(userProfile?)->Void){
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        userRef.getDocument{document, error in
            if error != nil {
                return completion(nil)
            }
            
            if let document = document, document.exists, let data = document.data() {
                let email = data["email"] as? String ?? "No email"
                let name = data["name"] as? String ?? "No name"
                let profile = Mental_Health.userProfile(firebase_uid: user.uid, email: email, name: name)
                completion(profile)
            } else {
                completion(nil)
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
