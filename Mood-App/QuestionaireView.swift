//
//  QuestionaireView.swift
//  Mental Health
//
//
//

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
    @State private var totalPointsEarned = 0 // Track total points for result pag
    // TEAMMATE NOTE: This array stores all the resultCategories that users select throughout the survey
    // Each time user picks an answer, that answer's resultCategory gets added to this list
    @State private var selectedCategories: [String] = []
    // Index of the mood question in the survey
    private let moodQuestionIndex = 1 // "How are you feeling overall today?"

    let questions: [QuestionData] = [
        QuestionData(
            question: "How have you been feeling emotionally this week?",
            options: [
                ("😵 Anxious, overwhelmed, or uncertain", "", 0, "Calm"),
                ("💤 Sluggish, tired, or low-energy", "", 0, "Movement"),
                ("😔 Burned out, unmotivated, or stuck", "", 0, "Focus"),
                ("🫥 Lonely or disconnected", "", 0, "Community"),
                ("🙂 Doing okay, but want more joy or purpose", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "What’s been hardest for you to manage lately?",
            options: [
                ("My thoughts and emotions", "", 0, "Calm"),
                ("My energy levels and physical health", "", 0, "Movement"),
                ("My ability to focus and stay productive", "", 0, "Focus"),
                ("My relationships or social life", "", 0, "Community"),
                ("My happiness and sense of fulfillment", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "When you're stressed, what’s your go-to response?",
            options: [
                ("I overthink or shut down", "", 0, "Calm"),
                ("I isolate myself", "", 0, "Community"),
                ("I try to power through but feel stuck", "", 0, "Focus"),
                ("I crash physically and need to rest", "", 0, "Movement"),
                ("I distract myself with hobbies or beauty rituals", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "How connected do you feel to other people right now?",
            options: [
                ("Very connected", "", 0, ""),
                ("Somewhat connected", "", 0, "Community"),
                ("Not very connected", "", 0, "Community"),
                ("I feel isolated or alone", "", 0, "Community")
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
                ("Being in nature or doing breathwork", "", 0, "Calm"),
                ("Creative hobbies (art, crafts)", "", 0, "Joy"),
                ("Talking to someone", "", 0, "Community"),
                ("Physical activity (yoga, dance)", "", 0, "Movement"),
                ("Journaling, meditation, skincare rituals", "", 0, "Joy_Focus")
            ],
            allowsMultipleSelection: true
        ),
        QuestionData(
            question: "Do you feel like you’re getting things done the way you’d like to?",
            options: [
                ("Yes, I’m managing well", "", 0, ""),
                ("Somewhat, but I struggle staying focused", "", 0, "Focus"),
                ("Not really, I feel unmotivated or behind", "", 0, "Focus")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "What do you wish you had more of in your life right now?",
            options: [
                ("Peace of mind", "", 0, "Calm"),
                ("Physical energy", "", 0, "Movement"),
                ("Productivity or motivation", "", 0, "Focus"),
                ("Deeper friendships or support", "", 0, "Community"),
                ("Joy or meaningful routines", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "When was the last time you did something just for yourself?",
            options: [
                ("Today", "", 0, ""),
                ("This week", "", 0, "Joy"),
                ("This month", "", 0, "Joy"),
                ("I honestly can’t remember", "", 0, "Joy")
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "Would you like support in any of the following areas?",
            options: [
                ("Managing stress or emotions", "", 0, "Calm"),
                ("Building a routine or setting goals", "", 0, "Focus"),
                ("Boosting physical health or movement", "", 0, "Movement"),
                ("Connecting with people or joining groups", "", 0, "Community"),
                ("Feeling happier or developing a self-care routine", "", 0, "Joy")
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
                        // ——— Removed the leading Spacer() ———

                        Text("Let’s get to know you better.")
                            .font(.custom("Alexandria-Regular", size: 24))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Text("Answer a couple questions to get started.")
                            .font(.custom("Alexandria-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Image("QuestionIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        VStack(spacing: 5) {
                            Text(questions[currentIndex].question)
                                .font(.custom("Alexandria-Regular", size: 18))
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Text(questions[currentIndex].allowsMultipleSelection ? "Select all that apply." : "Select one.")
                                .font(.custom("Alexandria-Regular", size: 14))
                                .foregroundColor(.gray)
                        }

                        ForEach(questions[currentIndex].options, id: \.text) { option in
                            Button(action: { toggleSelection(for: option.text) }) {
                                Text(option.text)
                                    .font(.custom("Alexandria-Regular", size: 16))
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

                        Button(action: handleNext) {
                            Image("NextButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 50)
                                .shadow(radius: 4)
                        }

                        ZStack(alignment: .leading) {
                            Capsule()
                                .frame(width: 319, height: 14)
                                .foregroundColor(Color(hex: "#C3B9D1"))

                            Capsule()
                                .frame(width: 319 * progress, height: 14)
                                .foregroundColor(Color(hex: "#8F81DC"))
                        }
                        .cornerRadius(20)
                        .padding(.top, 5)

                        // ——— Add a trailing Spacer() to push everything up ———
                        Spacer()
                    }
                    // ——— Make the VStack fill its parent and align to the top ———
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    // ——— Tweak the top padding to your liking ———
                    .padding(.top, 40)
                    .padding(.horizontal, 16)
                }
            }
            .navigationDestination(isPresented: $isFinished) {
                HomeView()
                    .environmentObject(storeData)
            }
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
        if selectedOptions.isEmpty {
            showAlert = true
            return
        }

        let selectedOption = selectedOptions.first!
        let currentQuestion = questions[currentIndex]
        if let optionIndex = currentQuestion.options.firstIndex(where: { $0.text == selectedOption }) {
            let option = currentQuestion.options[optionIndex]
            
            // TEAMMATE NOTE: Store the resultCategory from user's selected answer
            // This builds up the list of categories that will be analyzed at the end
            selectedCategories.append(option.resultCategory)
            
            // Only add points if the category is not empty
            if !option.category.isEmpty {
                storeData.addPoints(for: option.category, points: option.points)
                totalPointsEarned += option.points
            }
            // Only add mood entry for the mood question
            if currentIndex == moodQuestionIndex {
                if let mood = Mood(rawValue: selectedOption) {
                    storeData.addMoodEntry(mood: mood)
                }
            }
        }
        selectedOptions.removeAll()
        if currentIndex < questions.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        } else {
            // TEAMMATE NOTE: User finished all questions, now we analyze their category selections
            processCategoryResults()
            showLoading = true
            storeData.saveToFirestore()
        }
    }
    // TEAMMATE NOTE: This function counts which categories appeared most and ranks them
    // It stores the results in Firebase so your recommendation system can access them
    func processCategoryResults() {
        // Count how many times each category was selected
        var categoryCount: [String: Int] = [:]
        for category in selectedCategories {
            categoryCount[category, default: 0] += 1
        }
        
        // Sort categories by count (highest first), then alphabetically for ties
        // This ensures consistent ranking even when categories have same count
        let sortedCategories = categoryCount.sorted {
            if $0.value == $1.value {
                // If counts are equal, sort alphabetically for consistent results
                return $0.key < $1.key
            }
            // Otherwise sort by count (highest first)
            return $0.value > $1.value
        }
        
        // Create ranked result dictionary
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
        
        // TEAMMATE NOTE: Save the ranked categories to Firebase
        // Access this data using: storeData.categoryResults["first"], storeData.categoryResults["second"], etc.
        storeData.saveCategoryResults(rankedResults)
        
        // Debug print to see the results - shows exactly what you described
        print("TEAMMATE DEBUG - Category selections: \(selectedCategories)")
        print("TEAMMATE DEBUG - Category counts: \(categoryCount)")
        print("TEAMMATE DEBUG - Final ranked results: \(rankedResults)")
        
        // TEAMMATE DEBUG - Example output for [sad, sad, happy, sad, normal, normal]:
        // Category counts: ["sad": 3, "normal": 2, "happy": 1]
        // Final ranked results: ["first": "sad", "second": "normal", "third": "happy"]
        
        // TEAMMATE DEBUG - Example output for [sad, sad, happy, happy, normal]:
        // Category counts: ["sad": 2, "happy": 2, "normal": 1]
        // Final ranked results: ["first": "happy", "second": "sad", "third": "normal"]
        // (happy comes first because H < S alphabetically when counts are tied)
    }


}

#Preview {
    QuestionaireView()
        .environmentObject(StoreData())
}





