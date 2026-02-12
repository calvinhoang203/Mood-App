import SwiftUI

struct QuestionData {
    let question: String
    let options: [(text: String, category: String, points: Int, resultCategory: String)]
    let allowsMultipleSelection: Bool
}

struct QuestionaireView: View {
    @EnvironmentObject var storeData: StoreData
    @State private var rankedResults: [String: String] = [:]
    @State private var showResources = false
    @State private var currentIndex = 0
    @State private var selectedOptions: Set<String> = []
    @State private var showAlert = false
    @State private var isFinished = false
    @State private var showLoading = false
    @State private var totalPointsEarned = 0
    @State private var selectedCategories: [String] = []

    let questions: [QuestionData] = [
        QuestionData(
            question: "How are you feeling overall today?",
            options: [
                ("Great 😄", "POSITIVE_MOOD", 0, "Joy"),
                ("Okay 🙂", "NEUTRAL_MOOD", 0, "Calm"),
                ("Meh 😐", "NEUTRAL_MOOD", 0, "Focus"),
                ("Not so good 😞", "NEGATIVE_MOOD", 0, "Rest")
            ],
            allowsMultipleSelection: false
        ),
        // UPDATED: Shortened options for readability
        QuestionData(
            question: "How have you been feeling emotionally this week?",
            options: [
                ("😵 Anxious / Overwhelmed", "", 0, "Calm"),
                ("💤 Sluggish / Low energy", "", 0, "Movement"),
                ("😔 Burned out / Stuck", "", 0, "Focus"),
                ("🫥 Lonely / Disconnected", "", 0, "Community"),
                ("🙂 Okay, but seeking joy", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "What’s been hardest for you to manage lately?",
            options: [
                ("My thoughts and emotions", "", 0, "Calm"),
                ("My energy / physical health", "", 0, "Movement"),
                ("Focus and productivity", "", 0, "Focus"),
                ("Social life / Relationships", "", 0, "Community"),
                ("Happiness / Fulfillment", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        // UPDATED: Shortened options for readability
        QuestionData(
            question: "When you're stressed, what’s your go-to response?",
            options: [
                ("Overthinking / Shutting down", "", 0, "Calm"),
                ("Isolating myself", "", 0, "Community"),
                ("Powering through", "", 0, "Focus"),
                ("Crashing / Needing rest", "", 0, "Movement"),
                ("Distracting with hobbies", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "How connected do you feel to other people right now?",
            options: [
                ("Very connected", "", 0, ""),
                ("Somewhat connected", "", 0, "Community"),
                ("Not very connected", "", 0, "Community"),
                ("Isolated or alone", "", 0, "Community")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "How often do you move your body in a way that feels good?",
            options: [
                ("Almost every day", "", 0, ""),
                ("A few times a week", "", 0, "Movement"),
                ("Occasionally", "", 0, "Movement"),
                ("Rarely", "", 0, "Movement")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "What helps you reset or feel grounded?",
            options: [
                ("Nature / Breathwork", "", 0, "Calm"),
                ("Creative hobbies", "", 0, "Joy"),
                ("Talking to someone", "", 0, "Community"),
                ("Physical activity", "", 0, "Movement"),
                ("Journaling / Rituals", "", 0, "Joy_Focus")
            ],
            allowsMultipleSelection: true
        ),
        QuestionData(
            question: "Do you feel like you’re getting things done the way you’d like to?",
            options: [
                ("Yes, managing well", "", 0, ""),
                ("Somewhat, but struggle focusing", "", 0, "Focus"),
                ("No, feel unmotivated", "", 0, "Focus")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "What do you wish you had more of in your life right now?",
            options: [
                ("Peace of mind", "", 0, "Calm"),
                ("Physical energy", "", 0, "Movement"),
                ("Motivation", "", 0, "Focus"),
                ("Friendships / Support", "", 0, "Community"),
                ("Joy / Routine", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "When was the last time you did something just for yourself?",
            options: [
                ("Today", "", 0, ""),
                ("This week", "", 0, "Joy"),
                ("This month", "", 0, "Joy"),
                ("Can’t remember", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "Would you like support in any of the following areas?",
            options: [
                ("Managing stress", "", 0, "Calm"),
                ("Routine / Goals", "", 0, "Focus"),
                ("Physical health", "", 0, "Movement"),
                ("Connecting with people", "", 0, "Community"),
                ("Self-care / Happiness", "", 0, "Joy")
            ],
            allowsMultipleSelection: true
        )
    ]


    var progress: CGFloat {
        guard !questions.isEmpty else { return 0 }
        return CGFloat(currentIndex+1) / CGFloat(questions.count)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor").ignoresSafeArea()

                if showLoading {
                    LoadingView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                isFinished = true
                            }
                        }
                } else {
                    VStack(spacing: 20) {

                        Text("Let’s get to know you better.")
                            .font(.custom("Alexandria-Regular", size: 24))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40) // Added padding so title doesn't hit dynamic island

                        Text("Answer a couple questions to get started.")
                            .font(.custom("Alexandria-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Image("QuestionIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120) // Slightly smaller to save space

                        VStack(spacing: 5) {
                            Text(questions[currentIndex].question)
                                .font(.custom("Alexandria-Regular", size: 18))
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal)

                            Text(questions[currentIndex].allowsMultipleSelection ? "Select all that apply." : "Select one.")
                                .font(.custom("Alexandria-Regular", size: 14))
                                .foregroundColor(.gray)
                        }

                        // Options List
                        VStack(spacing: 10) {
                            ForEach(questions[currentIndex].options, id: \.text) { option in
                                Button(action: { toggleSelection(for: option.text) }) {
                                    Text(option.text)
                                        .font(.custom("Alexandria-Regular", size: 15)) // Adjusted size
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedOptions.contains(option.text) ? Color.purple : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)

                        Spacer() // Push button to bottom

                        Button(action: handleNext) {
                            Image("NextButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 50)
                                .shadow(radius: 4)
                        }
                        .padding(.bottom, 10)

                        ZStack(alignment: .leading) {
                            Capsule()
                                .frame(width: 319, height: 14)
                                .foregroundColor(Color(hex: "#C3B9D1"))

                            Capsule()
                                .frame(width: 319 * progress, height: 14)
                                .foregroundColor(Color(hex: "#8F81DC"))
                        }
                        .cornerRadius(20)
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationDestination(isPresented: $isFinished) {
                HomeView()
                    .environmentObject(storeData)
            }
            // Alert modifier is present, but won't trigger if logic is removed in handleNext
            .alert("Please choose an answer before continuing.", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    func toggleSelection(for option: String) {
        if questions[currentIndex].allowsMultipleSelection {
            if selectedOptions.contains(option) {
                selectedOptions.remove(option)
            } else {
                selectedOptions.insert(option)
            }
        } else {
            selectedOptions = [option]
        }
    }

    func handleNext() {
        // Validation removed to allow skipping
        /*
        if selectedOptions.isEmpty {
            showAlert = true
            return
        }
        */

        // Only process points if user actually selected something
        for selectedText in selectedOptions {
            if let optionIndex = questions[currentIndex].options.firstIndex(where: { $0.text == selectedText }) {
                let option = questions[currentIndex].options[optionIndex]
                
                selectedCategories.append(option.resultCategory)
                
                if !option.resultCategory.isEmpty {
                    storeData.addPoints(for: option.resultCategory, points: option.points)
                    totalPointsEarned += option.points
                }
                
                // Helper to map shortened text back to mood logic
                // Pass original text concepts if needed, or update inferMood
                if let mappedMood = inferMood(from: option.text, category: option.resultCategory) {
                    storeData.addMoodEntry(mood: mappedMood)
                }
            }
        }
        
        selectedOptions.removeAll()
        if currentIndex < questions.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        } else {
            processCategoryResults()
            showLoading = true
            storeData.addPoints(for: "SURVEY_COMPLETED", points: 10)
            storeData.checkAndUnlockBadges()
            storeData.saveToFirestore()
        }
    }
    
    // Updated inference to match new short text
    func inferMood(from text: String, category: String) -> Mood? {
        if text.contains("Great") { return .great }
        if text.contains("Okay") { return .okay }
        if text.contains("Meh") { return .meh }
        if text.contains("Not so good") { return .nsg }
        
        // Updated logic for shortened strings
        if text.contains("Anxious") || text.contains("Burned out") || text.contains("Lonely") { return .nsg }
        if text.contains("Sluggish") || text.contains("Overthinking") || text.contains("Isolating") { return .meh }
        if text.contains("Peace") || text.contains("stress") { return .okay }
        if text.contains("Joy") || text.contains("Happier") { return .great }
        
        return nil
    }
    
    func processCategoryResults() {
        var categoryCount: [String: Int] = [:]
        for category in selectedCategories {
            categoryCount[category, default: 0] += 1
        }
        
        let sortedCategories = categoryCount.sorted {
            if $0.value == $1.value {
                return $0.key < $1.key
            }
            return $0.value > $1.value
        }
        
        rankedResults = [:]
        for (index, categoryData) in sortedCategories.enumerated() {
            let rankKey: String
            switch index {
            case 0: rankKey = "first"
            case 1: rankKey = "second"
            case 2: rankKey = "third"
            case 3: rankKey = "fourth"
            case 4: rankKey = "fifth"
            default: rankKey = "rank_\(index + 1)"
            }
            rankedResults[rankKey] = categoryData.key
        }
        
        storeData.saveCategoryResults(rankedResults)
    }
}
