////
////  Question5View.swift
////  Mental Health
////
////  
////
//
//import SwiftUI
//
//struct Question5View: View {
//    var progress: CGFloat
//    let safeProgress: CGFloat
//    @State private var showAlert = false
//
//    init(progress: CGFloat = 0) {
//        self.progress = progress
//        self.safeProgress = progress.isFinite ? progress : 0
//    }
//    
//    @EnvironmentObject var surveyData: SurveyData
//    @State private var selectedOption: String?
//    @State private var goToNext = false
//
//    let options = [
//        ("Academic pressure and deadlines", "LOW ENERGY / MOTIVATION", 2),
//        ("Social situations and relationships", "NEED PEER/SOCIAL SUPPORT SYSTEM", 4),
//        ("Uncertainty about the future", "ANXIETY DUE TO LIFE CIRCUMSTANCES", 4),
//        ("Personal expectations and perfectionism", "STRESS DUE TO ACADEMIC PRESSURE", 4)
//    ]
//
//    var body: some View {
//        ZStack {
//            Color("lavenderColor").ignoresSafeArea()
//
//            VStack(spacing: 20) {
//                Spacer()
//
//                Text("Let’s get to know you better.")
//                    .font(.custom("Alexandria", size: 24))
//                    .foregroundColor(.black)
//                    .multilineTextAlignment(.center)
//
//                Text("Answer a couple questions to get started.")
//                    .font(.custom("Alexandria", size: 16))
//                    .foregroundColor(.black)
//                    .multilineTextAlignment(.center)
//
//                Image("QuestionIcon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 150, height: 150)
//
//                VStack(spacing: 5) {
//                    Text("What situations tend to affect your mood the most?")
//                        .font(.custom("Alexandria", size: 18))
//                        .bold()
//                        .foregroundColor(.black)
//                        .multilineTextAlignment(.center)
//                        .frame(maxWidth: .infinity, alignment: .center)
//
//
//                    Text("Select one.")
//                        .font(.custom("Alexandria", size: 14))
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                        .frame(maxWidth: .infinity, alignment: .center)
//
//                }
//
//                ForEach(options, id: \.0) { option in
//                    Button(action: {
//                        selectedOption = option.0
//                    }) {
//                        Text(option.0)
//                            .font(.custom("Alexandria", size: 16))
//                            .foregroundColor(.black)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(selectedOption == option.0 ? Color.purple : Color.clear, lineWidth: 2)
//                            )
//                    }
//                }
//
//                
//
//                Button(action: {
//                    if let selected = selectedOption,
//                       let match = options.first(where: { $0.0 == selected }) {
//                        surveyData.addPoints(for: match.1, points: match.2)
//                        goToNext = true
//                    } else {
//                        showAlert = true
//                    }
//                }) {
//                    Image("NextButton")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 160, height: 50)
//                        .shadow(radius: 4)
//                }
//
//                .disabled(selectedOption == nil)
//
//
//                ZStack(alignment: .leading) {
//                    Capsule()
//                        .frame(width: 319, height: 14)
//                        .foregroundColor(Color(hex: "#C3B9D1"))
//
//                    Capsule()
//                        .frame(width: 319 * safeProgress, height: 14)
//                        .foregroundColor(Color(hex: "#8F81DC"))
//                }
//                .cornerRadius(20)
//                .padding(.top, 5)
//            }
//            .padding()
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationDestination(isPresented: $goToNext) {
//            Question6View(progress: progress + 1/7)
//                .environmentObject(surveyData)
//        }
//        .alert("Please choose an answer before continuing.", isPresented: $showAlert) {
//            Button("OK", role: .cancel) { }
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        Question5View(progress: 5/7)
//            .environmentObject(SurveyData())
//    }
//}
