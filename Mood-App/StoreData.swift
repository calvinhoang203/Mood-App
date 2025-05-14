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
    
    // ─── Points system ───
    @Published var welcomeBonus: Int = 1000
    @Published var goalPoints:   Int = 300

    var totalPoints: Int {
        let spent = scores["spentUnlocks"] ?? 0
        let earned = scores.filter { $0.key != "spentUnlocks" }.map { $0.value }.reduce(0, +)
        return earned + welcomeBonus - spent
    }

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

        // Ensure spentUnlocks is always present
        if scores["spentUnlocks"] == nil {
            scores["spentUnlocks"] = 0
        }

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
                // Always ensure spentUnlocks is present
                var fixedScores = scoresData
                if fixedScores["spentUnlocks"] == nil {
                    fixedScores["spentUnlocks"] = 0
                }
                self.scores = fixedScores
            }

            if let notificationData = data["notifications"] as? [String: Bool] {
                self.notifications = notificationData
            }

            print("✅ User data loaded successfully.")
        }
    }

    // ── Analytics Page Properties ──────────────────────────────────────

    @Published var currentStreak: Int = 0
    @Published var badgeTitles: [String] = [
      "Bike Barn Boss", "Tercero Trekker", "Happy Heifer", "Fourth Badge"
    ]
    @Published var weeklyMoodData: [String: Double] = [
      "Happiness": 0, "Sadness": 0, "Anxiety": 0
    ]

    /// NEW: track lock/unlock state for each badge
    @Published var unlockedBadges: [Bool] = [false, false, false, false]

    /// Call this when a badge is earned
    func unlockBadge(at index: Int) {
      guard badgeTitles.indices.contains(index) else { return }
      unlockedBadges[index] = true
    }

    /// Displays "Week of Month Day"
    var weekRangeText: String {
      let start = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
      let df = DateFormatter()
      df.dateFormat = "MMMM d"
      return "Week of \(df.string(from: start))"
    }

    /// Fetches `currentStreak` and `weeklyMoodData` from Firestore
    func fetchAnalyticsData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("Users' info").document(uid)

        userRef.getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching analytics data: \(error.localizedDescription)")
                return
            }
            guard let data = snapshot?.data() else { return }

            // Firestore fields must match these keys
            self.currentStreak = data["currentStreak"] as? Int ?? 0
            if let moodMap = data["weeklyMoodData"] as? [String: Double] {
                self.weeklyMoodData = moodMap
            }
        }
    }

    /// A demo instance pre‐loaded with example data for SwiftUI previews
    static let demo: StoreData = {
        let sd = StoreData()
        sd.currentStreak = 5
        sd.weeklyMoodData = ["Happiness": 4, "Sadness": 1, "Anxiety": 2]
        return sd
    }()

    func deductPoints(_ points: Int) {
        // Deduct from a special key so totalPoints reflects deduction
        scores["spentUnlocks", default: 0] += points
        saveToFirestore()
    }
}
