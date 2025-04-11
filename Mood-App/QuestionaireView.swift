//
//  QuestionaireView.swift
//  Mental Health
//
//
//

import SwiftUI

struct QuestionData {
    let question: String
    let options: [(text: String, category: String, points: Int)]
    let allowsMultipleSelection: Bool
}

struct QuestionaireView: View {
    @EnvironmentObject var storeData: StoreData
    @State private var currentIndex = 0
    @State private var selectedOptions: Set<String> = []
    @State private var showAlert = false
    @State private var isFinished = false
    @State private var showLoading = false

    let questions: [QuestionData] = [
        QuestionData(
            question: "I want to learn how to . . .",
            options: [
                ("Better Deal With My Emotions", "LOW ENERGY / MOTIVATION", 1),
                ("Navigate Stress And Anxiety", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 2),
                ("Manage My Workload", "STRESS DUE TO ACADEMIC PRESSURE", 2),
                ("Practice Regular Self Care", "LOW ENERGY / MOTIVATION", 1),
                ("Gain Confidence And Grow", "NEED PEER/SOCIAL SUPPORT SYSTEM", 2)
            ],
            allowsMultipleSelection: true
        ),
        QuestionData(
            question: "How do you usually feel at the end of the day?",
            options: [
                ("Mentally drained and emotionally overwhelmed", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 4),
                ("Physically tired but emotionally fine", "LOW ENERGY / MOTIVATION", 1),
                ("Anxious about what’s next", "NEED PEER/SOCIAL SUPPORT SYSTEM", 2),
                ("Content and relaxed", "STRESS DUE TO ACADEMIC PRESSURE", 0)
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "How do you typically manage difficult emotions?",
            options: [
                ("I try to solve things logically on my own", "NEED PEER/SOCIAL SUPPORT SYSTEM", 0),
                ("I vent to my friends and family", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 2),
                ("I avoid or distract myself", "LOW ENERGY / MOTIVATION", 4),
                ("I engage in activities like journaling and meditation", "STRESS DUE TO ACADEMIC PRESSURE", 0)
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "How do you respond to feeling overwhelmed?",
            options: [
                ("I withdraw and spend time alone", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 2),
                ("I seek out people who make me feel better", "NEED PEER/SOCIAL SUPPORT SYSTEM", 4),
                ("I procrastinate and put things off", "LOW ENERGY / MOTIVATION", 0),
                ("I take small steps to feel more in control", "STRESS DUE TO ACADEMIC PRESSURE", 0)
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "What situations tend to affect your mood the most?",
            options: [
                ("Academic pressure and deadlines", "STRESS DUE TO ACADEMIC PRESSURE", 2),
                ("Social situations and relationships", "NEED PEER/SOCIAL SUPPORT SYSTEM", 4),
                ("Uncertainty about the future", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 4),
                ("Personal expectations and perfectionism", "STRESS DUE TO ACADEMIC PRESSURE", 4)
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "What’s your main goal for improving your mental health?",
            options: [
                ("Learning to better handle stress and anxiety", "STRESS DUE TO ACADEMIC PRESSURE", 0),
                ("Building stronger social connections", "NEED PEER/SOCIAL SUPPORT SYSTEM", 2),
                ("Finding balance and self-care routines", "LOW ENERGY / MOTIVATION", 0),
                ("Gaining confidence and self-awareness", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 2)
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "How do you prefer to get support when you need it?",
            options: [
                ("One-on-one counseling or therapy", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 3),
                ("Talking with friends or peers", "NEED PEER/SOCIAL SUPPORT SYSTEM", 2),
                ("Reading articles or using apps", "LOW ENERGY / MOTIVATION", 0),
                ("Joining a group or attending workshops", "STRESS DUE TO ACADEMIC PRESSURE", 0)
            ],
            allowsMultipleSelection: false
        ),
        QuestionData(
            question: "How do you describe your overall energy level throughout the day?",
            options: [
                ("I often feel drained and struggle to stay motivated", "LOW ENERGY / MOTIVATION", 0),
                ("My energy flunctuates depending on the situation", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 3),
                ("I usually have a steady level of energy", "STRESS DUE TO ACADEMIC PRESSURE", 0),
                ("I tend to feel energetic and motivated", "NEED PEER/SOCIAL SUPPORT SYSTEM", 4)
            ],
            allowsMultipleSelection: false
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
                            Spacer()

                            Text("Let’s get to know you better.")
                                .font(.custom("Alexandria", size: 24))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Text("Answer a couple questions to get started.")
                                .font(.custom("Alexandria", size: 16))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Image("QuestionIcon")
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

                            ForEach(questions[currentIndex].options, id: \ .text) { option in
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
            // 👇 This will allow the progress bar to visually fill before transitioning
            showLoading = true
            storeData.saveToFirestore()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                isFinished = true
            }
        }
    }


}

#Preview {
    QuestionaireView()
        .environmentObject(StoreData())
}
