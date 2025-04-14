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
        let documentID = currentUser.uid

        let userRef = db.collection("Users' info").document(documentID)

        let userData: [String: Any] = [
            "email": currentUser.email ?? email,
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "scores": scores,
            "notifications": notifications
        ]

        userRef.setData(userData) { error in
            if let error = error {
                print("❌ Error saving to Firestore: \(error.localizedDescription)")
            } else {
                print("✅ User data (profile + scores) saved successfully.")
            }
        }
    }
    
    // Notification variables
    @Published var notifications: [String: Bool] = [
        "account_created": false,
        "point_checkpoint": false,
        "daily_check_in": false
    ]
    
    //  Mark notification as seen for users
    func markNotificationAsSeen(_ key: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("Users' info").document(currentUser.uid)

        notifications[key] = true

        userRef.updateData([
            "notifications.\(key)": true
        ]) { error in
            if let error = error {
                print("❌ Error updating notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification '\(key)' marked as seen.")
            }
        }
    }

    // Load the notifications that have already been seen by users
    func loadUserDataFromFirestore() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("Users' info").document(currentUser.uid)

        userRef.getDocument { document, error in
            if let error = error {
                print("❌ Error loading user data: \(error.localizedDescription)")
                return
            }

            guard let data = document?.data() else {
                print("⚠️ No user data found.")
                return
            }

            self.firstName = data["firstName"] as? String ?? ""
            self.lastName = data["lastName"] as? String ?? ""
            self.phoneNumber = data["phoneNumber"] as? String ?? ""
            self.email = data["email"] as? String ?? ""

            if let scoresData = data["scores"] as? [String: Int] {
                self.scores = scoresData
            }

            if let notificationData = data["notifications"] as? [String: Bool] {
                self.notifications = notificationData
            }

            print("✅ User data loaded successfully.")
        }
    }

    

}


