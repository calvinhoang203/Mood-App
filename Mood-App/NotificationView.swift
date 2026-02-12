import SwiftUI

struct DiaryEntry: Identifiable {
    let id = UUID()
    let date: String
    let imageName: String
    let content: String
}

struct NotificationView: View {
    @EnvironmentObject var storeData: StoreData
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    // Navigation state
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false
    @State private var showNotification = false

    // Popup state
    @State private var selectedEntry: DiaryEntry? = nil
    @State private var showPopup = false

    private let navBarHeight: CGFloat = 64

    var userDiaryEntries: [DiaryEntry] {
        let imageOptions = ["Analytics Icon", "loginIcon", "LoadingIcon", "SurveyIcon"]

        let welcome = DiaryEntry(
            date: "Welcome to Moo'd!",
            imageName: "loginIcon",
            content: "This is where you will see your diary entries!"
        )

        let userEntries: [DiaryEntry] = storeData.journals
            .sorted(by: { lhs, rhs in
                let lhsNum = Int(lhs.key.replacingOccurrences(of: "entry", with: "")) ?? 0
                let rhsNum = Int(rhs.key.replacingOccurrences(of: "entry", with: "")) ?? 0
                return lhsNum > rhsNum
            })
            .compactMap { (_, value) in
                guard let text = value["text"], let dateStr = value["date"] else { return nil }
                let randomImage = imageOptions.randomElement() ?? "SurveyIcon"
                return DiaryEntry(date: dateStr, imageName: randomImage, content: text)
            }

        return userEntries + [welcome] // Welcome always at bottom
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // --- TOP BAR ---
                HStack {
                    Text("My Diary")
                        .font(.custom("Alexandria-Regular", size: 22))
                        .bold()
                        .padding(.top, 15)
                        .padding(.leading, 5)

                    Spacer()
/*
                    Button {
                        showHomeNav = true
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color("darkd3cpurple"))
                            .padding(.top, 12)
                            .padding(.trailing, 9)
                    }

                    Image("notification")
                        .resizable()
                        .frame(width: 30, height: 35)
                        .padding(.top, 15) */
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // --- SEARCH BAR ---
                TextField("Search diary...", text: $searchText)
                    .padding(15)
                    
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .focused($isSearchFocused)

                // --- ENTRIES LIST ---
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(userDiaryEntries.filter {
                            searchText.isEmpty ||
                            $0.date.lowercased().contains(searchText.lowercased()) ||
                            $0.content.lowercased().contains(searchText.lowercased())
                        }) { entry in
                            Button {
                                selectedEntry = entry
                                showPopup = true
                            } label: {
                                HStack(alignment: .top, spacing: 15) {
                                    Image(entry.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(entry.date)
                                            .font(.custom("Alexandria-Regular", size: 15))
                                            .bold()
                                            .foregroundColor(Color("darkd3cpurple")) // <-- fixed color
                                        Text(entry.content)
                                            .font(.custom("Alexandria-Regular", size: 13))
                                            .foregroundColor(.gray)
                                            .lineLimit(3)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 15)
                }
                .onTapGesture { isSearchFocused = false }

                // --- NAVBAR ---
                bottomTabBar
            }
            .navigationBarBackButtonHidden(true)
            .background(Color("lightd3cpurple").ignoresSafeArea())

            // --- NAV DESTINATIONS ---
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showPet) { PetView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .navigationDestination(isPresented: $showNotification) {
                NotificationView().environmentObject(storeData)
            }
        }
        // --- POPUP SHEET ---
        .sheet(item: $selectedEntry) { entry in
            VStack(alignment: .leading) {
                ScrollView {
                    Text(entry.date)
                        .font(.custom("Alexandria-Regular", size: 18))
                        .bold()
                        .padding(.bottom, 8)
                        .foregroundColor(Color("darkd3cpurple"))

                    Text(entry.content)
                        .font(.custom("Alexandria-Regular", size: 15))
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("lightd3cpurple"))
            .cornerRadius(20)
            .padding()
            .presentationDetents([.fraction(0.88)])
            .presentationDragIndicator(.visible)
        }
    }

    // --- NAVBAR DEFINITION ---
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

struct Notification_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .environmentObject(StoreData())
    }
}
