//
//  GoalView.swift
//  Mood-App
//

import SwiftUI
import UIKit

struct GoalView: View {
    @EnvironmentObject var storeData: StoreData
    
    @State private var currentStep = 0
    @State private var selectedOption: String?
    @State private var customInput: String = ""
    @State private var showAlert = false
    @State private var showLimitAlert = false
    @State private var showLoading = false
    @State private var goToHome = false

    // Navigation State
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false

    let steps: [GoalStep] = [
        GoalStep(
            title: "Set a tangible goal for yourself.",
            options: ["100 Points", "300 Points", "500 Points", "Custom Goal Set"]
        ),
        GoalStep(
            title: "Want to adjust your goal down?",
            options: ["No, keep it", "Subtract 50", "Subtract 100", "Custom Subtraction"]
        )
    ]

    var progress: CGFloat {
        CGFloat(currentStep + 1) / CGFloat(steps.count)
    }

    private let navBarHeight: CGFloat = 64
    
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
                        // Top Title
                        HStack {
                            Text("Goal Setting")
                                .font(.custom("Alexandria", size: 30))
                                .foregroundColor(.black)
                                .padding(.leading)
                            Spacer()
                        }

                        // Cow Icon
                        Image("QuestionIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        // Motivational Text
                        VStack(spacing: 5) {
                            Text("Let's get on track!\nTime to set a goal for yourself.")
                                .font(.custom("Alexandria-Regular", size: 18))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)

                            Text(steps[currentStep].title)
                                .font(.custom("Alexandria-Regular", size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 5)
                            
                            // UPDATED FONT HERE
                            Text("Current Goal Total: \(storeData.goalPoints)")
                                .font(.custom("Alexandria-Regular", size: 12)) // Fixed to match your font
                                .foregroundColor(.purple)
                                .padding(.top, 2)
                        }

                        // Options
                        ForEach(steps[currentStep].options, id: \.self) { option in
                            Button(action: {
                                // Toggle selection logic if you want clicking again to deselect
                                if selectedOption == option {
                                    selectedOption = nil
                                    customInput = ""
                                } else {
                                    selectedOption = option
                                    if !option.contains("Custom") {
                                        customInput = ""
                                    }
                                }
                            }) {
                                VStack {
                                    Text(option)
                                        .font(.custom("Alexandria-Regular", size: 16))
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedOption == option ? Color.purple : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }

                        // Custom Input Field
                        if let option = selectedOption, option.contains("Custom") {
                            TextField("Enter amount (e.g. 50)", text: $customInput)
                                .keyboardType(.numberPad)
                                .font(.custom("Alexandria-Regular", size: 16)) // Ensure input font matches too
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.purple, lineWidth: 1)
                                )
                                .padding(.horizontal)
                        }

                        // Next Button
                        Button(action: handleNextStep) {
                            Image("NextButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 50)
                                .shadow(radius: 4)
                        }
                        // Validation alert removed from logic, but modifier kept safe
                        .alert("Please choose an option before continuing.", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        }
                        .alert("Slow down!", isPresented: $showLimitAlert) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text("Please aim for a total goal lower than 1000 points.")
                        }

                        // Progress Bar
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
                        .padding(.bottom, navBarHeight)
                    }
                    .padding()
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
            .navigationDestination(isPresented: $goToHome) { HomeView() }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Logic
    func handleNextStep() {
        // ✅ UPDATED: Removed check for nil selection.
        // Users can now proceed without selecting an answer.
        
        /*
        if selectedOption == nil {
            showAlert = true
            return
        }
        */
        
        // STEP 0: ADDING POINTS
        if currentStep == 0 {
            if processAdditionStep() {
                withAnimation {
                    currentStep += 1
                    selectedOption = nil
                    customInput = ""
                }
            }
        }
        // STEP 1: SUBTRACTING POINTS
        else if currentStep == 1 {
            processSubtractionStep()
            storeData.saveToFirestore()
            showLoading = true
        }
    }
    
    func processAdditionStep() -> Bool {
        // If no option selected, default to 0 points added
        var pointsToAdd = 0
        
        if let option = selectedOption {
            if option == "100 Points" {
                pointsToAdd = 100
            } else if option == "300 Points" {
                pointsToAdd = 300
            } else if option == "500 Points" {
                pointsToAdd = 500
            } else if option == "Custom Goal Set", let custom = Int(customInput) {
                pointsToAdd = custom
            }
        }
        
        let potentialTotal = storeData.goalPoints + pointsToAdd
        
        if potentialTotal > 1000 {
            showLimitAlert = true
            return false
        } else {
            storeData.goalPoints += pointsToAdd
            print("Added \(pointsToAdd). New Total: \(storeData.goalPoints)")
            return true
        }
    }
    
    func processSubtractionStep() {
        // If no option selected, default to 0 points subtracted
        var pointsToSubtract = 0
        
        if let option = selectedOption {
            if option == "Subtract 50" {
                pointsToSubtract = 50
            } else if option == "Subtract 100" {
                pointsToSubtract = 100
            } else if option == "Custom Subtraction", let custom = Int(customInput) {
                pointsToSubtract = custom
            } else if option == "No, keep it" {
                pointsToSubtract = 0
            }
        }
        
        storeData.goalPoints = max(0, storeData.goalPoints - pointsToSubtract)
        print("Subtracted \(pointsToSubtract). Final Total: \(storeData.goalPoints)")
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

struct GoalStep {
    let title: String
    let options: [String]
}

#Preview {
    GoalView()
        .environmentObject(StoreData.demo)
}
