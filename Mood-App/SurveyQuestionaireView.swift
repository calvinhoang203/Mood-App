//
//  SurveyQuestionaireView.swift
//  Mood-App
//
//

import SwiftUI

struct SurveyQuestionData {
    let question: String
    let options: [(text: String, category: String, points: Int)]
    let allowsMultipleSelection: Bool
}

struct SurveyQuestionaireView: View {
    @EnvironmentObject var storeData: StoreData
    @State private var currentIndex = 0
    @State private var selectedOptions: Set<String> = []
    @State private var showAlert = false
    @State private var isFinished = false
    @State private var showLoading = false
    @Environment(\.dismiss) private var dismiss
    
    // Navigation state for all main screens
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false
    private let navBarHeight: CGFloat = 64

    let questions: [SurveyQuestionData] = [
        SurveyQuestionData(
            question: "How would you describe your mood today in one word?",
            options: [
                ("Joyful", "", 0),
                ("Stressed", "", 0),
                ("Tired", "", 0),
                ("Content", "", 0)
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "How are you feeling overall today?",
            options: [
                ("Great 😄", "", 0),
                ("Okay 🙂", "", 0),
                ("Meh 😐", "", 0),
                ("Not so good 😞", "", 0)
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "Which emotion best matches your current mood?",
            options: [
                ("Calm 😌", "", 0),
                ("Anxious 😬", "", 0),
                ("Sad 😢", "", 0),
                ("Energized ⚡", "", 0)
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "Did something specific affect your mood today?",
            options: [
                ("Yes, something positive", "", 0),
                ("Yes, something negative", "", 0),
                ("A mix of both", "", 0),
                ("Not really, it just is what it is", "", 0)
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "How well did you sleep last night?",
            options: [
                ("Very well", "", 0),
                ("Okay, not great", "", 0),
                ("Not much at all", "", 0),
                ("I don't remember", "", 0)
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "Did you eat a balanced meal today?",
            options: [
                ("Yes, I ate well", "", 0),
                ("I ate, but not very balanced", "", 0),
                ("Not yet, but I plan to", "", 0),
                ("No, not really", "", 0)
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "How socially connected do you feel today?",
            options: [
                ("Very connected", "", 0),
                ("Somewhat connected", "", 0),
                ("A bit isolated", "", 0),
                ("Very disconnected", "", 0)
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "Did you do something for yourself today (self-care, hobby, rest)?",
            options: [
                ("Yes, definitely", "", 0),
                ("A little bit", "", 0),
                ("Not yet, but I plan to", "", 0),
                ("No, not at all", "", 0)
            ],
            allowsMultipleSelection: false
        ),
        SurveyQuestionData(
            question: "What's your focus or intention for tomorrow?",
            options: [
                ("Take care of myself 💆‍♀️", "", 0),
                ("Get things done 💼", "", 0),
                ("Rest and recharge 🌿", "", 0),
                ("Connect with others 💬", "", 0)
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                isFinished = true
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
                            .font(.custom("Alexandria", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Image("SurveyIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        VStack(spacing: 5) {
                            Text(questions[currentIndex].question)
                                .font(.custom("Alexandria", size: 18))
                                .bold()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Text(questions[currentIndex].allowsMultipleSelection ? "Select all that apply." : "Select one.")
                                .font(.custom("Alexandria", size: 14))
                                .foregroundColor(.gray)
                        }

                        ForEach(questions[currentIndex].options, id: \.text) { option in
                            Button(action: {
                                toggleSelection(for: option.text)
                            }) {
                                Text(option.text)
                                    .font(.custom("Alexandria", size: 16))
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
                    }
                    .padding()
                    .padding(.bottom, navBarHeight)

                }
                
                VStack {
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
            .navigationDestination(isPresented: $isFinished) {
                HomeView()
                    .environmentObject(storeData)
            }
            .alert("Please choose an answer before continuing.", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
            .onChange(of: showLoading) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    dismiss()
                }
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

        // Placeholder for potential point system in future
        selectedOptions.removeAll()

        if currentIndex < questions.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        } else {
            showLoading = true
            storeData.saveToFirestore()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showLoading = false
                dismiss()
            }
        }
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
        .background(Color.white)
    }
}

#Preview {
    SurveyQuestionaireView()
        .environmentObject(StoreData())
}
