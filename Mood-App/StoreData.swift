import Foundation
import FirebaseFirestore
import FirebaseAuth

// MARK: - Main Class
class StoreData: ObservableObject {
    @Published var scores: [String: Int] = [
        "ANXIETY DUE TO LIFE CIRCUMSTANCES": 0,
        "NEED PEER/SOCIAL SUPPORT SYSTEM": 0,
        "STRESS DUE TO ACADEMIC PRESSURE": 0,
        "LOW ENERGY / MOTIVATION": 0
    ]
    
    @Published var welcomeBonus: Int = 50
    @Published var goalPoints: Int = 300
    @Published var totalBadgePoints: Int = 0
    @Published var goalSetPoints: Int = 0
    @Published var unlockedBadges: [Bool] = Array(repeating: false, count: 12)
    
    // Custom Quote
    @Published var customQuote: String = "Worrying does not take away tomorrow's troubles. It takes away today's peace."
    
    @Published var moodEntries: [MoodEntry] = []
    @Published var weeklyMoodDistribution: [Emotion: Int] = [
        .great: 0, .okay: 0, .meh: 0, .nsg: 0
    ]
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var pronouns: String = ""
    @Published var phoneNumber: String = ""
    @Published var email: String = ""
    
    @Published var journals: [String: [String: String]] = [:]
    @Published var categoryResults: [String: String] = [:]
    
    @Published var notifications: [String: Bool] = [
        "account_created": false,
        "point_checkpoint": false,
        "daily_check_in": false
    ]
    
    @Published var currentStreak: Int = 0
    @Published var weeklyMoodData: [String: Double] = [
        "Happiness": 0, "Sadness": 0, "Anxiety": 0
    ]
    
    @Published var badgeTitles: [String] = [
        "Library Scholar", "Boba Enthusiast", "Rec Sports MVP", "Spa Day Specialist",
        "Bike Barn Boss", "Library Scholar", "Piercing Perfectionist", "Farmer’s Market Fashionista",
        "Arboretum Explorer", "MU Gaming Area Champion", "It-Girl Aggie", "Rec Sports MVP"
    ]
    
    @Published var badgeScores: [Int] = [150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650, 1800]

    var weekRangeText: String {
        let start = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let df = DateFormatter()
        df.dateFormat = "MMMM d"
        return "Week of \(df.string(from: start))"
    }
    
    var checkInDaysThisWeekCount: Int {
        let calendar = Calendar.current
        let thisWeekEntries = entriesFromCurrentWeek(moodEntries)
        let uniqueDays = Set(thisWeekEntries.map { calendar.startOfDay(for: $0.date) })
        return uniqueDays.count
    }
    
    func hasCheckedInToday() -> Bool {
        let calendar = Calendar.current
        return moodEntries.contains { calendar.isDateInToday($0.date) }
    }
    
    // MARK: - UPDATED: AVERAGE MOOD LOGIC
    // Calculates the average mood value (Great=4, Okay=3, Meh=2, NSG=1)
    var dominantMoodIcon: String {
        // Get counts from the weekly distribution
        let greatCount = Double(weeklyMoodDistribution[.great] ?? 0)
        let okayCount  = Double(weeklyMoodDistribution[.okay] ?? 0)
        let mehCount   = Double(weeklyMoodDistribution[.meh] ?? 0)
        let nsgCount   = Double(weeklyMoodDistribution[.nsg] ?? 0)
        
        let totalCount = greatCount + okayCount + mehCount + nsgCount
        
        // If no entries, default to okay
        guard totalCount > 0 else { return "moodokay" }
        
        // Calculate weighted sum
        // Great = 4, Okay = 3, Meh = 2, NSG = 1
        let totalScore = (greatCount * 4.0) + (okayCount * 3.0) + (mehCount * 2.0) + (nsgCount * 1.0)
        
        // Calculate average
        let average = totalScore / totalCount
        
        // Round to nearest integer
        let roundedAverage = Int(round(average))
        
        // Map back to image name
        switch roundedAverage {
        case 4: return "moodhappy"      // Average is ~Great
        case 3: return "moodokay"       // Average is ~Okay
        case 2: return "moodmeh"        // Average is ~Meh
        case 1: return "moodnotsogood"  // Average is ~Not so good
        default: return "moodokay"      // Fallback
        }
    }
    
    // Points Logic
    var totalPoints: Int {
        let spent = scores["spentUnlocks"] ?? 0
        let relevantKeys = ["SURVEY_COMPLETED", "JOURNAL_ENTRY"]
        let earned = scores.filter { relevantKeys.contains($0.key) }
            .map { $0.value }
            .reduce(0, +)
        return earned + welcomeBonus - spent
    }
    
    var lifetimePoints: Int {
        let relevantKeys = ["SURVEY_COMPLETED", "JOURNAL_ENTRY"]
        let earned = scores.filter { relevantKeys.contains($0.key) }
            .map { $0.value }
            .reduce(0, +)
        return earned + welcomeBonus
    }
    
    func addPoints(for category: String, points: Int) {
        scores[category, default: 0] += points
    }
    
    func deductPoints(_ points: Int) {
        scores["spentUnlocks", default: 0] += points
        saveToFirestore()
    }
    
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
            
            DispatchQueue.main.async {
                self.currentStreak = data["currentStreak"] as? Int ?? 0
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
    }
    
    static let demo: StoreData = {
        let sd = StoreData()
        sd.currentStreak = 5
        sd.weeklyMoodData = ["Happiness": 4, "Sadness": 1, "Anxiety": 2]
        sd.moodEntries = [
            .init(date: Date().addingTimeInterval(-86400 * 0), mood: .meh),
            .init(date: Date().addingTimeInterval(-86400 * 1), mood: .okay)
        ]
        sd.updateWeeklyMoodDistribution()
        return sd
    }()
}

// MARK: - Mood Tracking & Badges
extension StoreData {
    func addMoodEntry(mood: Mood) {
        let newEntry = MoodEntry(date: Date(), mood: mood)
        moodEntries.append(newEntry)
        updateWeeklyMoodDistribution()
        saveToFirestore()
    }
    
    func updateWeeklyMoodDistribution() {
        initializeEmptyMoodDistribution()
        let weekEntries = entriesFromCurrentWeek(moodEntries)
        let distribution = emotionDistribution(from: weekEntries)
        for (emotion, count) in distribution {
            weeklyMoodDistribution[emotion] = count
        }
    }
    
    func initializeEmptyMoodDistribution() {
        weeklyMoodDistribution = [
            .great: 0, .okay: 0, .meh: 0, .nsg: 0
        ]
    }
    
    func applyInitialBadgePoints() {
        let spent = scores["spentUnlocks"] ?? 0
        totalBadgePoints += welcomeBonus - spent
    }
    
    func addBadgePoints(points: Int) {
        applyInitialBadgePoints()
        totalBadgePoints += points
    }
    
    func checkBadgeStatus() -> Int? {
        applyInitialBadgePoints()
        for index in 0..<badgeScores.count {
            guard index < unlockedBadges.count else { continue }
            // Check if user has enough points AND the badge is currently locked
            if totalBadgePoints >= badgeScores[index], !unlockedBadges[index] {
                return index
            }
        }
        return nil
    }
    
    func unlockBadge(at index: Int) {
        applyInitialBadgePoints()
        guard badgeTitles.indices.contains(index) else { return }
        unlockedBadges[index] = true
        // Optionally trigger a save here if needed
    }
    
    func badgeCheckpoint(at index: Int) -> Bool {
        applyInitialBadgePoints()
        return totalBadgePoints >= badgeScores[index]
    }
    
    func checkAndUnlockBadges() {
        let badgeThresholds = [150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650, 1800]
        for (index, threshold) in badgeThresholds.enumerated() {
            if lifetimePoints >= threshold && !unlockedBadges[index] {
                unlockedBadges[index] = true
            }
        }
    }
}

// MARK: - Firestore
extension StoreData {
    func saveToFirestore() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("Users' info").document(currentUser.uid)
        
        let moodEntriesData: [[String: Any]] = moodEntries.map {
            ["date": $0.date, "mood": $0.mood.rawValue]
        }
        
        let userData: [String: Any] = [
            "email": currentUser.email ?? email,
            "firstName": firstName,
            "lastName": lastName,
            "pronouns": pronouns,
            "phoneNumber": phoneNumber,
            "scores": scores.filter { !$0.key.isEmpty },
            "notifications": notifications,
            "moodEntries": moodEntriesData,
            "currentStreak": currentStreak,
            "journals": journals,
            "totalBadgePoints": totalBadgePoints,
            "goalSetPoints": goalSetPoints,
            "unlockedBadges": unlockedBadges,
            "welcomeBonus": welcomeBonus,
            "goalPoints": goalPoints,
            "categoryResults": categoryResults,
            "customQuote": customQuote
        ]
        
        userRef.setData(userData, merge: true)
    }
    
    func loadUserDataFromFirestore() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userRef = Firestore.firestore().collection("Users' info").document(currentUser.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("❌ Error loading user data: \(error.localizedDescription)")
                return
            }
            guard let data = document?.data() else { return }
            
            self.firstName = data["firstName"] as? String ?? ""
            self.lastName = data["lastName"] as? String ?? ""
            self.pronouns = data["pronouns"] as? String ?? ""
            self.phoneNumber = data["phoneNumber"] as? String ?? ""
            self.email = data["email"] as? String ?? ""
            self.goalPoints = data["goalPoints"] as? Int ?? 0
            self.totalBadgePoints = data["totalBadgePoints"] as? Int ?? 0
            self.goalSetPoints = data["goalSetPoints"] as? Int ?? 0
            self.unlockedBadges = data["unlockedBadges"] as? [Bool] ?? []
            self.categoryResults = data["categoryResults"] as? [String: String] ?? [:]
            self.notifications = data["notifications"] as? [String: Bool] ?? self.notifications
            self.journals = data["journals"] as? [String: [String: String]] ?? [:]
            self.currentStreak = data["currentStreak"] as? Int ?? 0
            self.customQuote = data["customQuote"] as? String ?? "Worrying does not take away tomorrow's troubles. It takes away today's peace."
            
            if let scoresData = data["scores"] as? [String: Int] {
                self.scores = scoresData
                if self.scores["spentUnlocks"] == nil {
                    self.scores["spentUnlocks"] = 0
                }
            }
            
            if let moodData = data["moodEntries"] as? [[String: Any]] {
                self.moodEntries = moodData.compactMap {
                    guard let ts = $0["date"] as? Timestamp,
                          let moodStr = $0["mood"] as? String,
                          let mood = Mood(rawValue: moodStr) else { return nil }
                    return MoodEntry(date: ts.dateValue(), mood: mood)
                }
                self.updateWeeklyMoodDistribution()
            }
            
            if self.unlockedBadges.count < self.badgeScores.count {
                self.unlockedBadges += Array(repeating: false, count: self.badgeScores.count - self.unlockedBadges.count)
            }
            self.checkAndUnlockBadges()
        }
    }
}

// MARK: - Journals & Category Saving
extension StoreData {
    func addJournalEntry(text: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let dateString = formatter.string(from: Date())
        let key = "entry\(journals.count + 1)"
        journals[key] = ["text": text, "date": dateString]
        
        // Award 10 points for journaling
        addPoints(for: "JOURNAL_ENTRY", points: 10)
        saveToFirestore()
    }
    
    func saveCategoryResults(_ rankedResults: [String: String]) {
        self.categoryResults = rankedResults
        guard let user = Auth.auth().currentUser else { return }
        let userRef = Firestore.firestore().collection("Users' info").document(user.uid)
        userRef.updateData(["categoryResults": rankedResults])
    }
}

// MARK: - Reset
extension StoreData {
    func reset() {
        firstName = ""; lastName = ""; pronouns = ""; phoneNumber = ""; email = ""
        scores = [
            "ANXIETY DUE TO LIFE CIRCUMSTANCES": 0,
            "NEED PEER/SOCIAL SUPPORT SYSTEM": 0,
            "STRESS DUE TO ACADEMIC PRESSURE": 0,
            "LOW ENERGY / MOTIVATION": 0
        ]
        moodEntries = []; currentStreak = 0
        weeklyMoodDistribution = [.great: 0, .okay: 0, .meh: 0, .nsg: 0]
        unlockedBadges = Array(repeating: false, count: 12)
        totalBadgePoints = 0
        journals = [:]; notifications = ["account_created": false, "point_checkpoint": false, "daily_check_in": false]
        weeklyMoodData = ["Happiness": 0, "Sadness": 0, "Anxiety": 0]
        categoryResults = [:]
        customQuote = "Worrying does not take away tomorrow's troubles. It takes away today's peace."
    }
    
    func updateStreakIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let hasEntryToday = moodEntries.contains { calendar.isDate($0.date, inSameDayAs: today) }
        if !hasEntryToday {
            currentStreak += 1
            saveToFirestore()
        }
    }
    
    func markNotificationAsSeen(_ key: String) {
        guard let user = Auth.auth().currentUser else { return }
        notifications[key] = true
        Firestore.firestore()
            .collection("Users' info")
            .document(user.uid)
            .updateData(["notifications.\(key)": true])
    }
}
