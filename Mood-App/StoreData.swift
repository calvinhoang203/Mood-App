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

    @Published var welcomeBonus: Int = 50
    @Published var goalPoints:   Int = 300
    @Published var totalBadgePoints: Int = 0
    @Published var goalSetPoints: Int = 0
    @Published var unlockedBadges: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false]


<<<<<<< Updated upstream
=======
    // ─── Mood tracking for analytics ───
    @Published var moodEntries: [MoodEntry] = []
    @Published var weeklyMoodDistribution: [Emotion: Int] = [
        .great: 0,
        .okay: 0,
        .meh: 0,
        .nsg: 0
    ]

    //??
>>>>>>> Stashed changes
    var totalPoints: Int {
        let spent = scores["spentUnlocks"] ?? 0 //
        let earned = scores.filter { $0.key != "spentUnlocks" }.map { $0.value }.reduce(0, +)
        return earned + welcomeBonus - spent
    }
    
    func applyInitialBadgePoints() {
        let spent = scores["spentUnlocks"] ?? 0
        totalBadgePoints += welcomeBonus - spent
    }
    
    // User profile info
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var email: String = ""

    func addPoints(for category: String, points: Int) {
        scores[category, default: 0] += points
    }
<<<<<<< Updated upstream
=======
    
    // Add a new mood entry ONLY for the mood question
    func addMoodEntry(mood: Mood) {
        let newEntry = MoodEntry(date: Date(), mood: mood)
        moodEntries.append(newEntry)
        updateWeeklyMoodDistribution()
        saveToFirestore()
    }
    
    // Update streak if this is a new day
    func updateStreakIfNeeded() {
        let calendar = Calendar.current
        
        // Check if there's already an entry for today
        let today = calendar.startOfDay(for: Date())
        let hasEntryToday = moodEntries.contains { entry in
            calendar.isDate(entry.date, inSameDayAs: today)
        }
        
        // If this is the first entry today, increment streak
        if !hasEntryToday {
            currentStreak += 1
            saveToFirestore()
        }
    }

    // Initialize with empty values for all emotions
    func initializeEmptyMoodDistribution() {
        weeklyMoodDistribution = [
            .great: 0,
            .okay: 0,
            .meh: 0,
            .nsg: 0
        ]
    }
    
    // Update weekly mood distribution for the chart
    func updateWeeklyMoodDistribution() {
        // Start with empty values
        initializeEmptyMoodDistribution()
        
        // Then update with actual entries
        let weekEntries = entriesFromCurrentWeek(moodEntries)
        let distribution = emotionDistribution(from: weekEntries)
        // Merge the distributions
        for (emotion, count) in distribution {
            weeklyMoodDistribution[emotion] = count
        }
        
        print("Updated mood distribution: \(weeklyMoodDistribution)")
    }
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "scores": scores,
            "notifications": notifications
=======
                "firstName": firstName,
                "lastName": lastName,
                "pronouns": pronouns,
                "phoneNumber": phoneNumber,
                "scores": filteredScores,
                "notifications": notifications,
                "moodEntries": moodEntriesData,
                "currentStreak": currentStreak,
                "journals": journals,
                // Add these:
                "totalBadgePoints": totalBadgePoints,
                "goalSetPoints": goalSetPoints,
                "unlockedBadges": unlockedBadges,
                "welcomeBonus": welcomeBonus,
                "goalPoints": goalPoints

>>>>>>> Stashed changes
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
            self.goalPoints = data["goalPoints"] as? Int ?? 0

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
<<<<<<< Updated upstream
=======
            
            // Load mood entries
            if let moodEntriesData = data["moodEntries"] as? [[String: Any]] {
                self.moodEntries = moodEntriesData.compactMap { entryData in
                    guard let dateTimestamp = entryData["date"] as? Timestamp,
                          let moodString = entryData["mood"] as? String,
                          let mood = Mood(rawValue: moodString) else {
                        return nil
                    }
                    return MoodEntry(date: dateTimestamp.dateValue(), mood: mood)
                }
                self.updateWeeklyMoodDistribution()
            }
            
            // Load streak
            if let streak = data["currentStreak"] as? Int {
                self.currentStreak = streak
            }

            // Load journals if present
            if let journalsData = data["journals"] as? [String: [String: String]] {
                self.journals = journalsData
            }
            self.totalBadgePoints = data["totalBadgePoints"] as? Int ?? 0
            self.goalSetPoints = data["goalSetPoints"] as? Int ?? 0
            self.unlockedBadges = data["unlockedBadges"] as? [Bool] ?? []
>>>>>>> Stashed changes

            print("✅ User data loaded successfully.")
        }
    }

    // ── Analytics Page Properties ──────────────────────────────────────

    @Published var currentStreak: Int = 0
    @Published var weeklyMoodData: [String: Double] = [
      "Happiness": 0, "Sadness": 0, "Anxiety": 0
    ]
    
    // ── Badge Section  ──────────────────────────────────────
    @Published var badgeTitles: [String] = [
      "Baby Aggie", "Boba Enthusiast", "CoHo Connoisseur", "Spa Day Specialist", "Bike Barn Boss", "Library Scholar", "Piercing Perfectionist", "Farmer’s Market Fashionista", "Arboretum Explorer", "MU Gaming Area Champion", "It-Girl Aggie", "Rec Sports MVP"
    ]
    @Published var badgeScores: [Int] = [50, 100, 200, 400, 700, 1000, 1500, 2000, 3000, 4000, 5000, 7000]
    
    func addBadgePoints(points: Int) {
        applyInitialBadgePoints()
        totalBadgePoints += points
    }


    /// NEW: track lock/unlock state for each badge
    /// @Published var unlockedBadges: [Bool] = [false, false, false, false]
    
    func checkBadgeStatus() -> Int? {
        applyInitialBadgePoints()
        for index in 0..<badgeScores.count {
                if totalBadgePoints > badgeScores[index] && !unlockedBadges[index] {
                    return index
                }
            }
            return nil
    }

    // can also just make a disctionary here to avoid two seperate arrays*****
    /// Call this when a badge is earned
    func unlockBadge(at index: Int) {
        applyInitialBadgePoints()
      guard (badgeTitles.indices.contains(index) && badgeCheckpoint(at: index)) else { return }
      unlockedBadges[index] = true
    }
    
<<<<<<< Updated upstream
    func checkAndUnlockBadges(){
        let badgeThresholds = [100, 500, 1000, 2000]  // Match with badge index
            for (index, threshold) in badgeThresholds.enumerated() {
                if totalPoints >= threshold && !unlockedBadges[index] {
                    unlockBadge(at: index)
                    print("Badge unlocked at index \(index)!: \(badgeTitles[index])")
                }
            }
=======
    func badgeCheckpoint(at index: Int) -> Bool {
        applyInitialBadgePoints()
        if(totalBadgePoints >= badgeScores[index]){
            return true
        }
        return false
>>>>>>> Stashed changes
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
    
    

<<<<<<< Updated upstream
    
=======
    /// Clears all user-related data in memory (does NOT touch Firestore)
    func reset() {
        firstName = ""
        lastName = ""
        pronouns = ""
        phoneNumber = ""
        email = ""
        scores = [
            "ANXIETY DUE TO LIFE CIRCUMSTANCES": 0,
            "NEED PEER/SOCIAL SUPPORT SYSTEM": 0,
            "STRESS DUE TO ACADEMIC PRESSURE": 0,
            "LOW ENERGY / MOTIVATION": 0
        ]
        moodEntries = []
        weeklyMoodDistribution = [
            .great: 0,
            .okay: 0,
            .meh: 0,
            .nsg: 0
        ]
        notifications = [
            "account_created": false,
            "point_checkpoint": false,
            "daily_check_in": false
        ]
        currentStreak = 0
        badgeTitles = [
            "Bike Barn Boss", "Tercero Trekker", "Happy Heifer", "Fourth Badge"
        ]
        weeklyMoodData = [
            "Happiness": 0, "Sadness": 0, "Anxiety": 0
        ]
        journals = [:]
        totalBadgePoints = 0
        goalSetPoints = 0
        unlockedBadges = []
    }
>>>>>>> Stashed changes

}
