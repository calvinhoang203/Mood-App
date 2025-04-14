//
//  SurveyQuestionaireView.swift
//  Mood-App
//
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

    let questions: [SurveyQuestionData] = [
        SurveyQuestionData(
            question: "What is your current stress level?",
            options: [
                ("Very High", "STRESS DUE TO ACADEMIC PRESSURE", 3),
                ("Moderate", "STRESS DUE TO ACADEMIC PRESSURE", 2),
                ("Low", "LOW ENERGY / MOTIVATION", 1),
                ("No Stress", "LOW ENERGY / MOTIVATION", 0)
            ],
            allowsMultipleSelection: false
        )
        // ✅ Add more questions later
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

                        Text("Let’s get to know you better.")
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
                }
            }
            .navigationDestination(isPresented: $isFinished) {
                ProfileView()
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

        for selected in selectedOptions {
            if let match = questions[currentIndex].options.first(where: { $0.text == selected }) {
                storeData.addPoints(for: match.category, points: match.points)
            }
        }

        selectedOptions.removeAll()

        if currentIndex < questions.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        } else {
            showLoading = true
            storeData.saveToFirestore()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                isFinished = true
            }
        }
    }
}

#Preview {
    SurveyQuestionaireView()
        .environmentObject(StoreData())
}
