//
//  GoalView.swift
//  Mood-App
//

import SwiftUI

struct GoalView: View {
    @State private var currentStep = 0
    @State private var selectedOption: String?
    @State private var showAlert = false
    @State private var isCompleted = false

    @State private var showHomeNav      = false
    @State private var showResourceNav  = false
    @State private var showSetGoalNav   = false
    @State private var showAnalyticsNav = false
    @State private var showSettingNav   = false
    
    
    let steps: [GoalStep] = [
        GoalStep(
            title: "Set a tangible goal for yourself.",
            options: ["Daily Check Ins", "300 Points", "500 Points", "Custom Goal Set"]
        ),
        GoalStep(
            title: "Set your timeline.",
            options: ["1 Week", "1 Month", "3 Months", "Custom Time Frame"]
        )
    ]

    var progress: CGFloat {
        CGFloat(currentStep + 1) / CGFloat(steps.count)
    }

    private let navBarHeight: CGFloat = 50
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor").ignoresSafeArea()

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
                        Text("Let’s get on track!\nTime to set a goal for yourself.")
                            .font(.custom("Alexandria", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)

                        Text(steps[currentStep].title)
                            .font(.custom("Alexandria", size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }

                    // Options
                    ForEach(steps[currentStep].options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                        }) {
                            Text(option)
                                .font(.custom("Alexandria", size: 16))
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

                    // ✅ Image-based Next Button
                    Button(action: {
                        if selectedOption == nil {
                            showAlert = true
                        } else {
                            if currentStep < steps.count - 1 {
                                currentStep += 1
                                selectedOption = nil
                            } else {
                                isCompleted = true
                            }
                        }
                    }) {
                        Image("NextButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 50)
                            .shadow(radius: 4)
                    }
                    .alert("Please choose an option before continuing.", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
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
                VStack {
                    Spacer()
                    bottomTabBar
                }
            }
            .navigationDestination(isPresented: $isCompleted) {
                // You can link to Dashboard() or any next view
                Text("Goal setup complete!")
            }
        }
        .navigationDestination(isPresented: $showHomeNav)      { HomeView() }
        .navigationDestination(isPresented: $showResourceNav)  { ResourcesView() }
        .navigationDestination(isPresented: $showSetGoalNav)   { SetGoalView() }
        .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
        .navigationDestination(isPresented: $showSettingNav)   { SettingView() }
        .navigationBarBackButtonHidden(true)
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
            Button { withAnimation(.none) { showResourceNav = true } } label: {
                Image("Resource Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showSetGoalNav = true } } label: {
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
        .background(Color.white.opacity(0.9))
    }
}

struct GoalStep {
    let title: String
    let options: [String]
}

#Preview {
    GoalView()
}
