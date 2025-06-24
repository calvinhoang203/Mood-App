//
//  SurveyQuestionaireView.swift
//  Mood-App
//
//

import SwiftUI
import UIKit

struct SurveyQuestionData {
    let question: String
    let options: [(text: String, category: String, points: Int, resultCategory: String)]
    let allowsMultipleSelection: Bool
}

struct SurveyQuestionaireView: View {
    @EnvironmentObject var storeData: StoreData
    @State private var currentIndex = 0
    @State private var selectedOptions: Set<String> = []
    @State private var showAlert = false
    @State private var isFinished = false
    @State private var showLoading = false
    @State private var totalPointsEarned = 0 // Track total points for result page
    @State private var goToHome = false // New navigation state

    // TEAMMATE NOTE: This array stores all the resultCategories that users select throughout the survey
    // Each time user picks an answer, that answer's resultCategory gets added to this list
    @State private var selectedCategories: [String] = []

    @Environment(\.dismiss) private var dismiss

    // Navigation state for all main screens
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false
    private let navBarHeight: CGFloat = 64
    
    // Index of the mood question in the survey
    private let moodQuestionIndex = 1 // "How are you feeling overall today?"
    private let moodPoints = 50 // Points earned for answering the mood question

    let questions: [SurveyQuestionData] = [
        SurveyQuestionData(
            question: "How would you describe your mood today in one word?",
            options: [
                // TEAMMATE NOTE: Add your resultCategory as the 4th parameter for each answer
                // Example format: ("answer text", "points category", points, "your result category")
                ("Joyful", "", 0, "POSITIVE_MOOD"),
                ("Stressed", "", 0, "STRESS_RELATED"),
                ("Tired", "", 0, "ENERGY_RELATED"),
                ("Content", "", 0, "POSITIVE_MOOD")
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "How are you feeling overall today?",
            options: [
                ("Great 😄", "MOOD_TRACKING", 50, "POSITIVE_MOOD"),
                ("Okay 🙂", "MOOD_TRACKING", 50, "NEUTRAL_MOOD"),
                ("Meh 😐", "MOOD_TRACKING", 50, "NEUTRAL_MOOD"),
                ("Not so good 😞", "MOOD_TRACKING", 50, "NEGATIVE_MOOD")
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "Which emotion best matches your current mood?",
            options: [
                ("Calm 😌", "", 0, "POSITIVE_MOOD"),
                ("Anxious 😬", "", 0, "ANXIETY_RELATED"),
                ("Sad 😢", "", 0, "NEGATIVE_MOOD"),
                ("Energized ⚡", "", 0, "ENERGY_RELATED")
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "Did something specific affect your mood today?",
            options: [
                ("Yes, something positive", "", 0, "POSITIVE_MOOD"),
                ("Yes, something negative", "", 0, "NEGATIVE_MOOD"),
                ("A mix of both", "", 0, "MIXED_MOOD"),
                ("Not really, it just is what it is", "", 0, "NEUTRAL_MOOD")
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "How well did you sleep last night?",
            options: [
                ("Very well", "", 0, "GOOD_HEALTH"),
                ("Okay, not great", "", 0, "MODERATE_HEALTH"),
                ("Not much at all", "", 0, "POOR_HEALTH"),
                ("I don't remember", "", 0, "NEUTRAL_HEALTH")
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "Did you eat a balanced meal today?",
            options: [
                ("Yes, I ate well", "", 0, "GOOD_HEALTH"),
                ("I ate, but not very balanced", "", 0, "MODERATE_HEALTH"),
                ("Not yet, but I plan to", "", 0, "PLANNING_HEALTH"),
                ("No, not really", "", 0, "POOR_HEALTH")
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "How socially connected do you feel today?",
            options: [
                ("Very connected", "", 0, "SOCIAL_POSITIVE"),
                ("Somewhat connected", "", 0, "SOCIAL_MODERATE"),
                ("A bit isolated", "", 0, "SOCIAL_NEGATIVE"),
                ("Very disconnected", "", 0, "SOCIAL_NEGATIVE")
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "Did you do something for yourself today (self-care, hobby, rest)?",
            options: [
                ("Yes, definitely", "", 0, "SELF_CARE_POSITIVE"),
                ("A little bit", "", 0, "SELF_CARE_MODERATE"),
                ("Not yet, but I plan to", "", 0, "SELF_CARE_PLANNING"),
                ("No, not at all", "", 0, "SELF_CARE_NEGATIVE")
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "What's your focus or intention for tomorrow?",
            options: [
                ("Take care of myself 💆‍♀️", "", 0, "SELF_CARE_FOCUS"),
                ("Get things done 💼", "", 0, "PRODUCTIVITY_FOCUS"),
                ("Rest and recharge 🌿", "", 0, "RECOVERY_FOCUS"),
                ("Connect with others 💬", "", 0, "SOCIAL_FOCUS")
            ],
            allowsMultipleSelection: false
        )
    ]

    var progress: CGFloat {
        guard !questions.isEmpty else { return 0 }
        return CGFloat(currentIndex + 1) / CGFloat(questions.count)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor").ignoresSafeArea()

                if showLoading {
                    LoadingView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                showLoading = false
                                goToHome = true
                            }
                        }
                } else {
                    VStack(spacing: 20) {
                        Spacer()

                        Text("Let's get to know you better.")
                            .font(.custom("Alexandria", size: 24))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Text("Answer a couple questions to get started.")
                            .font(.custom("Alexandria-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Image("SurveyIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        VStack(spacing: 5) {
                            Text(questions[currentIndex].question)
                                .font(.custom("Alexandria-Regular", size: 18))
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity)
                            Text(questions[currentIndex].allowsMultipleSelection ? "Select all that apply." : "Select one.")
                                .font(.custom("Alexandria-Regular", size: 14))
                                .foregroundColor(.gray)
                        }

                        ForEach(questions[currentIndex].options, id: \.text) { option in
                            Button(action: {
                                toggleSelection(for: option.text)
                            }) {
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
                        .padding(.bottom, 30)
                    }
                    .padding()
                    .padding(.bottom, navBarHeight)

                }
                
                VStack(spacing: 0) {
                    Spacer()
                    bottomTabBar
                }
            }
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showPet) { PetView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .navigationDestination(isPresented: $goToHome) {
                HomeView().environmentObject(storeData)
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
        var rankedResults: [String: String] = [:]
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
    
    private var bottomTabBar: some View {
        HStack {
            Spacer()
            Button { withAnimation(.none) { showHomeNav = true } } label: {
                Image("Home Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showResource = true } } label: {
                Image("Resource Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showSetGoal = true } } label: {
                Image("Set Goal Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showAnalyticsNav = true } } label: {
                Image("Analytics Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showSettingNav = true } } label: {
                Image("Setting Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
        }
        .frame(height: navBarHeight)
        .padding(.top, 8)
        .background(
            Color.white
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -2)
        )
    }
}

#Preview {
    SurveyQuestionaireView()
        .environmentObject(StoreData())
}
