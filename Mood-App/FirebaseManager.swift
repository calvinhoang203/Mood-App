//
//  FirebaseManager.swift
//  Mental Health
//
//
//

import FirebaseFirestore
import FirebaseAuth

class FirebaseManager {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()

    func savePoints(categoryScores: [String: Int], completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        let data = categoryScores.mapValues { ["points": $0] }

        db.collection("storeScores").document(user.uid).setData(data, merge: true) { error in
            if let error = error {
                print("Error saving data: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Scores saved successfully.")
                completion(true)
            }
        }
    }
}
