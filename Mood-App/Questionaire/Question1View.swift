////
////  Question1View.swift
////  Mental Health
////
//
//import SwiftUI
//
//struct Question1View: View {
//    var progress: CGFloat
//    let safeProgress: CGFloat
//
//    init(progress: CGFloat = 0) {
//        self.progress = progress
//        self.safeProgress = progress.isFinite ? progress : 0
//    }
//
//    @State private var selectedOptions: Set<String> = []
//    @State private var goToNext = false
//    @State private var showAlert = false
//
//    let options = [
//        "Better Deal With My Emotions",
//        "Navigate Stress And Anxiety",
//        "Manage My Workload",
//        "Practice Regular Self Care",
//        "Gain Confidence And Grow"
//    ]
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color("lavenderColor").ignoresSafeArea()
//
//                VStack(spacing: 20) {
//                    Spacer()
//
//                    Text("Let’s get to know you better.")
//                        .font(.custom("Alexandria", size: 24))
//                        .foregroundColor(.black)
//                        .multilineTextAlignment(.center)
//
//                    Text("Answer a couple questions to get started.")
//                        .font(.custom("Alexandria", size: 16))
//                        .foregroundColor(.black)
//                        .multilineTextAlignment(.center)
//
//                    Image("QuestionIcon")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 150, height: 150)
//
//                    VStack(spacing: 5) {
//                        Text("I want to learn how to . . .")
//                            .font(.custom("Alexandria", size: 18))
//                            .bold()
//                            .foregroundColor(.black)
//
//                        Text("Select all that apply.")
//                            .font(.custom("Alexandria", size: 14))
//                            .foregroundColor(.gray)
//                    }
//
//                    ForEach(options, id: \.self) { option in
//                        Button(action: {
//                            toggleSelection(option)
//                        }) {
//                            Text(option)
//                                .font(.custom("Alexandria", size: 16))
//                                .foregroundColor(.black)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(selectedOptions.contains(option) ? Color.purple : Color.clear, lineWidth: 2)
//                                )
//                        }
//                    }
//
//                    // 🟢 Next Button with validation
//                    Button(action: {
//                        if selectedOptions.isEmpty {
//                            showAlert = true
//                        } else {
//                            goToNext = true
//                        }
//                    }) {
//                        Image("NextButton")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 160, height: 50)
//                            .shadow(radius: 4)
//                    }
//
//                    // ✅ Styled Progress Bar
//                    ZStack(alignment: .leading) {
//                        Capsule()
//                            .frame(width: 319, height: 14)
//                            .foregroundColor(Color(hex: "#C3B9D1"))
//
//                        Capsule()
//                            .frame(width: 319 * safeProgress, height: 14)
//                            .foregroundColor(Color(hex: "#8F81DC"))
//                    }
//                    .cornerRadius(20)
//                    .padding(.top, 5)
//                }
//                .padding()
//            }
//            .navigationBarBackButtonHidden(true)
//
//            // ✅ Navigate to Question2View if selection is valid
//            .navigationDestination(isPresented: $goToNext) {
//                Question2View(progress: progress + 1/7)
//            }
//
//            // ⚠️ Alert if no option selected
//            .alert("Please select at least one option before continuing.", isPresented: $showAlert) {
//                Button("OK", role: .cancel) { }
//            }
//        }
//    }
//
//    func toggleSelection(_ option: String) {
//        if selectedOptions.contains(option) {
//            selectedOptions.remove(option)
//        } else {
//            selectedOptions.insert(option)
//        }
//    }
//}
//
//#Preview {
//    Question1View(progress: 0)
//}
