//import SwiftUI
//
//struct Dashboard: View {
//    @State private var isLoading = true // Start with loading as true
//    @State private var currency = 265
//    @EnvironmentObject var sharedData: SharedData
//    let images = [("reward", "Coffee"), ("reward", "Necklace"), ("reward", "Plant")]
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // Check if the image exists and display it
//                if let _ = UIImage(named: "mentalhealthapp") {
//                    Image("mentalhealthapp")
//                        .resizable()
//                        .frame(width: UIScreen.main.bounds.width)
//                        .aspectRatio(contentMode: .fit)
//                        .ignoresSafeArea()
//                } else {
//                    // Fallback view if the image is not found
//                    Color.gray
//                        .ignoresSafeArea()
//                    Text("Image not found: mentalhealthapp")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                }
//
//                VStack(spacing: 0) {
//                    // Scrollable content
//                    ScrollView {
//                        VStack(spacing: 20) {
//                            // Welcome Text
//                            Text("Welcome \(sharedData.name)")
//                                .font(.custom("Jua", size: 25))
//                                .foregroundColor(sharedData.titleColor)
//                                .frame(maxWidth: .infinity)
//
//                            // Cow Image
//                            Image("cow")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 275, height: 150)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(sharedData.textColor, lineWidth: 4))
//                                .shadow(radius: 10)
//                                .padding(.bottom, 20)
//
//                            // Quote Text
//                            VStack {
//                                Text("""
//                                ”Worrying does not take away tomorrow's troubles. It takes away today's peace.”
//                                \n~ Randy Armstrong
//                                """)
//                                .foregroundColor(sharedData.textColor)
//                                .font(.custom("Jua", size: 14))
//                                .multilineTextAlignment(.center)
//                                .padding(40)
//                            }
//                            .frame(width: UIScreen.main.bounds.width * 0.85)
//                            .background(sharedData.lighttext)
//                            .cornerRadius(10)
//                            .shadow(radius: 10)
//
//                            // Check-In Button
//                            Button(action: {}) {
//                                Text("Start a Check-In")
//                                    .textCase(.uppercase)
//                                    .font(.custom("Jua", size: 15))
//                                    .frame(width: 150, height: 50)
//                                    .foregroundColor(sharedData.lighttext)
//                                    .background(sharedData.buttoncolor)
//                                    .cornerRadius(10)
//                                    .padding(25)
//                            }
//
//                            // Dashboard Section
//                            VStack {
//                                Text("DASHBOARD")
//                                    .foregroundColor(sharedData.textColor)
//                                    .font(.custom("Jua", size: 20))
//                                    .padding(.top, 20)
//
//                                // Progress Bar
//                                ProgressBar(currency: $currency, bar: Color("rightblue"), textColor: sharedData.textColor)
//                                    .padding(.bottom, 50)
//                            }
//                            .frame(width: UIScreen.main.bounds.width * 0.85)
//                            .background(sharedData.lighttext)
//                            .cornerRadius(10)
//                            .shadow(radius: 10)
//
//                            // Rewards Section
//                            VStack {
//                                Text("REWARDS")
//                                    .foregroundColor(sharedData.textColor)
//                                    .font(.custom("Jua", size: 20))
//                                    .padding(.bottom, 10)
//
//                                // Horizontal ScrollView for Rewards
//                                ScrollView(.horizontal, showsIndicators: false) {
//                                    HStack(spacing: 20) {
//                                        ForEach(images, id: \.1) { imageName, label in
//                                            VStack {
//                                                Image(imageName)
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .frame(width: 100, height: 100)
//                                                    .cornerRadius(10)
//                                                Text(label)
//                                                    .font(.custom("Jua", size: 15))
//                                                    .foregroundColor(sharedData.textColor)
//                                                    .padding(.top, 10)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            .frame(width: UIScreen.main.bounds.width * 0.85, height: 250)
//                            .background(sharedData.lighttext)
//                            .cornerRadius(10)
//                            .padding(20)
//                            .shadow(radius: 10)
//                        }
//                        .frame(minHeight: UIScreen.main.bounds.height) // Stretch content to full screen height
//                    }
//                    homebar()
//                }
//                .opacity(isLoading ? 0 : 1) // Hide main content when loading
//
//                // Loading view
//                if isLoading {
//                    LoadView()
//                }
//            }
//            .onAppear {
//                networkCall()
//            }
//            .statusBar(hidden: true) // Hide the status bar
//            .navigationBarHidden(true) // Hide navigation bar
//            .navigationBarBackButtonHidden(true) // Hide the back button
//        }
//    }
//
//    func networkCall() {
//        isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            isLoading = false
//        }
//    }
//}
//
//// ProgressBar Component
//struct ProgressBar: View {
//    @Binding var currency: Int
//    var bar: Color
//    var textColor: Color
//
//    var body: some View {
//        VStack {
//            HStack {
//                Text("You have \(currency) points")
//                    .foregroundColor(textColor)
//                    .font(.custom("Jua", size: 14))
//                    .padding(.top, 20)
//            }
//
//            ProgressView(value: Double(currency) / 1000.0)
//                .frame(width: 270)
//                .scaleEffect(x: 1, y: 3, anchor: .center)
//                .padding(20)
//                .tint(bar)
//
//            HStack {
//                Text("\(1000 - currency) points away from next reward")
//                    .font(.custom("Jua", size: 10))
//                    .foregroundColor(textColor)
//            }
//        }
//    }
//}
//
//// LoadView Component
//struct LoadView: View {
//    @EnvironmentObject var sharedData: SharedData
//
//    var body: some View {
//        ZStack {
//            Color(sharedData.topColor).ignoresSafeArea()
//            VStack {
//                Text("MOO'D")
//                    .font(.custom("Jua", size: 50))
//                    .foregroundColor(sharedData.textColor)
//
//                Image("logosamp")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 275, height: 150)
//
//                Spacer()
//
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: sharedData.textColor))
//                    .scaleEffect(1.5)
//                    .padding(50)
//            }
//            .frame(width: 400, height: 150, alignment: .center)
//        }
//    }
//}
