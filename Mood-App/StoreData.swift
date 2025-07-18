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

    @Published var welcomeBonus: Int = 1500

    @Published var goalPoints:   Int = 300

    // ─── Mood tracking for analytics ───
    @Published var moodEntries: [MoodEntry] = []
    @Published var weeklyMoodDistribution: [Emotion: Int] = [
        .great: 0,
        .okay: 0,
        .meh: 0,
        .nsg: 0
    ]

    var totalPoints: Int {
        let spent = scores["spentUnlocks"] ?? 0
        let earned = scores.filter { $0.key != "spentUnlocks" }.map { $0.value }.reduce(0, +)
        return earned + welcomeBonus - spent
    }

    // User profile info
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var pronouns: String = ""
    @Published var phoneNumber: String = ""
    @Published var email: String = ""

    // ─── Journal Entries ───
    @Published var journals: [String: [String: String]] = [:]
    
    // ─── Category Results for Recommendation System ───
    // TEAMMATE NOTE: This stores the ranked categories from survey results
    // Access like: storeData.categoryResults["first"] to get the top category
    // 
    // EXAMPLE USAGE FOR YOUR RECOMMENDATION SYSTEM:
    // let topCategory = storeData.categoryResults["first"] ?? "NO_DATA"
    // let secondCategory = storeData.categoryResults["second"] ?? "NO_DATA"
    // 
    // Available keys: "first", "second", "third", "fourth", "fifth"
    // Categories come from the survey answers (like "POSITIVE_MOOD", "ANXIETY_RELATED", etc.)
    @Published var categoryResults: [String: String] = [:]

    func addPoints(for category: String, points: Int) {
        scores[category, default: 0] += points
    }
    
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
        
        // Filter out any empty-string keys from scores
        let filteredScores = scores.filter { !$0.key.isEmpty }
        
        // Convert mood entries to a format that can be stored in Firestore
        let moodEntriesData: [[String: Any]] = moodEntries.map { entry in
            return [
                "date": entry.date,
                "mood": entry.mood.rawValue
            ]
        }

        let userRef = db.collection("Users' info").document(documentID)

        let userData: [String: Any] = [
            "email": currentUser.email ?? email,
            "firstName": firstName,
            "lastName": lastName,
            "pronouns": pronouns,
            "phoneNumber": phoneNumber,
            "scores": filteredScores,
            "notifications": notifications,
            "moodEntries": moodEntriesData,
            "currentStreak": currentStreak,
            "journals": journals,
            "categoryResults": categoryResults
        ]

        userRef.setData(userData, merge: true) { error in
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
            self.pronouns = data["pronouns"] as? String ?? ""
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
            
            // TEAMMATE NOTE: Load category results from Firebase
            // This loads the ranked categories that your recommendation system needs
            if let categoryResultsData = data["categoryResults"] as? [String: String] {
                self.categoryResults = categoryResultsData
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

            self.currentStreak = data["currentStreak"] as? Int ?? 0
            // Load mood entries for the chart
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
        }
    }

    /// A demo instance pre‐loaded with example data for SwiftUI previews
    static let demo: StoreData = {
        let sd = StoreData()
        sd.currentStreak = 5
        
        // Add sample mood entries for demo
        let sampleEntries: [MoodEntry] = [
            .init(date: Date().addingTimeInterval(-86400 * 0), mood: .meh),
            .init(date: Date().addingTimeInterval(-86400 * 1), mood: .okay),
            .init(date: Date().addingTimeInterval(-86400 * 2), mood: .great),
            .init(date: Date().addingTimeInterval(-86400 * 3), mood: .meh),
            .init(date: Date().addingTimeInterval(-86400 * 4), mood: .nsg),
            .init(date: Date().addingTimeInterval(-86400 * 5), mood: .meh),
            .init(date: Date().addingTimeInterval(-86400 * 6), mood: .nsg)
        ]
        sd.moodEntries = sampleEntries
        sd.updateWeeklyMoodDistribution()
        
        return sd
    }()

    func deductPoints(_ points: Int) {
        // Deduct from a special key so totalPoints reflects deduction
        scores["spentUnlocks", default: 0] += points
        saveToFirestore()
    }

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
        unlockedBadges = [false, false, false, false]
        journals = [:]
        categoryResults = [:]
    }

    /// Returns an array of (weekStart, mood distribution) for each week with mood entries, sorted by weekStart ascending
    var weeklyMoodDistributions: [(weekStart: Date, distribution: [Emotion: Int])] {
        // Group entries by week start (Monday)
        let calendar = Calendar(identifier: .iso8601)
        let grouped = Dictionary(grouping: moodEntries) { entry -> Date in
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: entry.date)
            return calendar.date(from: components) ?? entry.date
        }
        // For each week, compute the mood distribution
        let weekDistributions = grouped.map { (weekStart, entries) -> (Date, [Emotion: Int]) in
            let dist = emotionDistribution(from: entries)
            return (weekStart, dist)
        }
        // Sort by weekStart ascending
        return weekDistributions.sorted { $0.0 < $1.0 }
    }

    // Add a new journal entry with unique key and formatted date
    func addJournalEntry(text: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let dateString = formatter.string(from: Date())
        let nextIndex = journals.count + 1
        let key = "entry\(nextIndex)"
        journals[key] = ["text": text, "date": dateString]
        saveToFirestore()
    }
    
    // TEAMMATE NOTE: This function saves the ranked category results to Firebase
    // Call this after processing survey responses to store recommendation data
    // The ranked results will be available for your recommendation system
    func saveCategoryResults(_ rankedResults: [String: String]) {
        self.categoryResults = rankedResults
        
        // Save specifically to Firebase
        guard let currentUser = Auth.auth().currentUser else {
            print("❌ User not logged in - cannot save category results")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("Users' info").document(currentUser.uid)
        
        userRef.updateData([
            "categoryResults": rankedResults
        ]) { error in
            if let error = error {
                print("❌ Error saving category results: \(error.localizedDescription)")
            } else {
                print("✅ Category results saved successfully!")
                print("TEAMMATE INFO - Saved results: \(rankedResults)")
                print("TEAMMATE INFO - Access with: storeData.categoryResults[\"first\"], storeData.categoryResults[\"second\"], etc.")
            }
        }
    }
}
