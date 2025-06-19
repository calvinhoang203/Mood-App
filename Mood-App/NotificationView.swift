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
    
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false
    @State private var showCheckInFlow = false

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

        return userEntries + [welcome] // Show welcome at bottom
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Diary")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    Spacer()
                    Image("Bookmark Icon")
                }
                .padding()

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $searchText)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal)

                // Entries
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(userDiaryEntries.filter {
                            searchText.isEmpty ||
                            $0.date.lowercased().contains(searchText.lowercased()) ||
                            $0.content.lowercased().contains(searchText.lowercased())
                        }) { entry in
                            HStack(alignment: .top, spacing: 15) {
                                Image(entry.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.date)
                                        .font(.headline)
                                    Text(entry.content)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(3)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }

                // Bottom tab bar
                bottomTabBar
                    .padding()
                    .background(Color.white)
                    .shadow(radius: 5)
            }
            .background(Color.lavender)

            // Navigation destinations
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showPet) { PetView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .navigationDestination(isPresented: $showCheckInFlow) {
                NotificationView().environmentObject(storeData)
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
    }
}
struct Notification_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .environmentObject(StoreData())
    }
}

