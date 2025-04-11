//
//  StoreData.swift
//  Mental Health
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class StoreData: ObservableObject {
    @Published var scores: [String: Int] = [
        "ANXIETY DUE TO LIFE CIRCUMSTANCES": 0,
        "NEED PEER/SOCIAL SUPPORT SYSTEM": 0,
        "STRESS DUE TO ACADEMIC PRESSURE": 0,
        "LOW ENERGY / MOTIVATION": 0
    ]

    // User profile info
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var email: String = ""

    func addPoints(for category: String, points: Int) {
        scores[category, default: 0] += points
    }

    func saveToFirestore() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }

        let db = Firestore.firestore()
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        let documentID = fullName.isEmpty ? currentUser.uid : fullName

        let userRef = db.collection("Users' info").document(documentID)

        let userData: [String: Any] = [
            "email": currentUser.email ?? email,
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "scores": scores
        ]

        userRef.setData(userData) { error in
            if let error = error {
                print("❌ Error saving to Firestore: \(error.localizedDescription)")
            } else {
                print("✅ User data (profile + scores) saved successfully.")
            }
        }
    }
}
