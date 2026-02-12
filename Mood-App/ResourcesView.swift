import SwiftUI

struct ResourcesView: View {
    @State private var searchText: String = ""
    @StateObject private var savedItems = SavedItems()
    @State private var navigateToSaved = false
    @State private var navigateToHome = false
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showSettingNav = false
    @State private var showNotification = false

    @FocusState private var isSearchFocused: Bool
    let navBarHeight: CGFloat = 64

    @EnvironmentObject var storeData: StoreData

    var topTags: [String] {
        let topCategory = storeData.categoryResults["first"] ?? ""
        return [topCategory]
    }

    let allActivities: [Activity] = [
        Activity(
            name: "Meditation",
            imageName: "resourcemed",
            description: "Meditation calms racing thoughts, reduces stress, and grounds you. Try guided sessions or just breathe quietly on the Quad.",
            tags: ["Calm"]
        ),
        Activity(
            name: "Energy-reset stretch breaks",
            imageName: "resourceenergyreset",
            description: "Between study sessions, stretch with shoulder rolls or cat-cow to refresh your body and regain focus.",
            tags: ["Movement"]
        ),
        Activity(
            name: "Pomodoro technique",
            imageName: "resourcepomodoro",
            description: "Work for 25 minutes, break for 5. After 4 rounds, rest longer. A proven method to stay focused and avoid burnout.",
            tags: ["Focus"]
        ),
        Activity(
            name: "Collaborative projects",
            imageName: "resourcecollab",
            description: "Group up for class, clubs, or side projects. Brainstorm, study, or build something meaningful with friends.",
            tags: ["Community"]
        ),
        Activity(
            name: "Nature time",
            imageName: "resourcewalk",
            description: "Walk the Arboretum, study in a park, or sit under a tree. Nature lifts your mood and brings calm joy.",
            tags: ["Joy"]
        )
    ]

    let allResources: [Resource] = [
        Resource(
            name: "South Hall Therapy",
            imageName: "resourcesouthhalltherapy",
            description: "South Hall offers free, confidential counseling for UC Davis students facing stress, anxiety, or tough times.\n📍 South Hall near Memorial Union\n🕒 Mon–Fri, 8a–5p",
            tags: ["Calm"]
        ),
        Resource(
            name: "Campus Recreation",
            imageName: "resourcecampusrec",
            description: "Join free or low-cost classes like boxing, yoga, and pilates to boost your mood and meet others.\n📍 ARC, La Rue Rd\n🕒 Mon–Sun, various hours.",
            tags: ["Movement"]
        ),
        Resource(
            name: "AATC (Tutoring Center)",
            imageName: "resourceaatc",
            description: "Get help with tutoring, writing, or study skills — for anything from calculus to time management.\n📍 Dutton Hall, South Hall, Silo\n🕒 Mon–Fri, 9a–7p",
            tags: ["Focus"]
        ),
        Resource(
            name: "CLL (Leadership Learning)",
            imageName: "resourcecll",
            description: "Build leadership skills through workshops, peer programs, and community events.\n📍 1350 The Grove\n🕒 Mon–Fri, 9a–5p",
            tags: ["Community"]
        ),
        Resource(
            name: "Volunteer Center",
            imageName: "resourcevolunteer",
            description: "Find volunteer opportunities that match your interests — from animals to education to the environment.\n📍 South Hall (ICC, 2nd Floor)\n🕒 Mon–Fri, 10a–4p",
            tags: ["Joy"]
        )
    ]

    var filteredActivities: [Activity] {
        let base = searchText.isEmpty
            ? allActivities
            : allActivities.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        return base.sorted {
            let aMatches = Set($0.tags).intersection(topTags).count
            let bMatches = Set($1.tags).intersection(topTags).count
            return aMatches > bMatches
        }
    }

    var filteredResources: [Resource] {
        let base = searchText.isEmpty
            ? allResources
            : allResources.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        return base.sorted {
            let aMatches = Set($0.tags).intersection(topTags).count
            let bMatches = Set($1.tags).intersection(topTags).count
            return aMatches > bMatches
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear

                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - UPDATED HEADER
                    HStack(alignment: .center) {
                        Text("Discover ways to cope.")
                            .font(.custom("Alexandria-Regular", size: 22))
                            .bold()

                        Spacer()
                        
                        // Group icons together with spacing
                        HStack(spacing: 12) {
                            Button {
                                navigateToHome = true
                            } label: {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color("darkd3cpurple"))
                            }

                            Button {
                                showNotification = true
                            } label: {
                                Image("Bookmark Icon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            .navigationDestination(isPresented: $showNotification) {
                                NotificationView().environmentObject(storeData)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)

                    TextField("Search...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .focused($isSearchFocused)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            Text("Activities List")
                                .font(.custom("Alexandria-Regular", size: 17))
                                .padding(.horizontal)

                            if filteredActivities.isEmpty {
                                Text("No matching activities found.")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(filteredActivities) { activity in
                                            ActivityCard(activity: activity, topTags: topTags)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            Text("Resources List")
                                .font(.custom("Alexandria-Regular", size: 17))
                                .padding(.horizontal)

                            if filteredResources.isEmpty {
                                Text("No matching resources found.")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(filteredResources) { resource in
                                            ResourceCard(resource: resource, topTags: topTags)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }

                    Spacer()
                }
                .onTapGesture {
                    isSearchFocused = false
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(Color("lightd3cpurple").ignoresSafeArea())
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
        }
    }
}

// MARK: – ActivityCard

struct ActivityCard: View {
    let activity: Activity
    let topTags: [String]
    @EnvironmentObject var savedItems: SavedItems

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(activity.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Text(activity.name)
                    .font(.custom("Alexandria-Regular", size: 15))
                    .bold()
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                ForEach(activity.tags.prefix(2), id: \.self) { tag in
                    HStack(spacing: 4) {
                        Text(tag.capitalized)
                            .font(.caption2)
                        if topTags.contains(tag) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.purple.opacity(0.15))
                    .cornerRadius(8)
                }
            }

            Text(activity.description)
                .font(.custom("Alexandria-Regular", size: 12))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

            // Pushes content up since the button is no longer taking space here
            Spacer()
        }
        .padding()
        .frame(width: 230, height: 300)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        // MARK: - Overlay Heart Icon
        .overlay(alignment: .topTrailing) {
            Button(action: {
                savedItems.toggleActivity(activity)
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                    
                    Image(systemName: savedItems.isActivitySaved(activity) ? "heart.fill" : "heart")
                        .foregroundColor(.blue)
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .padding(12) // Padding from the top-right edges
        }
    }
}

// MARK: – ResourceCard

struct ResourceCard: View {
    let resource: Resource
    let topTags: [String]
    @EnvironmentObject var savedItems: SavedItems

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(resource.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Text(resource.name)
                    .font(.custom("Alexandria-Regular", size: 15))
                    .bold()
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                ForEach(resource.tags.prefix(2), id: \.self) { tag in
                    HStack(spacing: 4) {
                        Text(tag.capitalized)
                            .font(.caption2)
                        if topTags.contains(tag) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.purple.opacity(0.15))
                    .cornerRadius(8)
                }
            }

            Text(resource.description)
                .font(.custom("Alexandria-Regular", size: 12))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding()
        .frame(width: 230, height: 350)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        // MARK: - Overlay Bookmark Icon
        .overlay(alignment: .topTrailing) {
            Button(action: {
                savedItems.toggleResource(resource)
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                    
                    Image(systemName: savedItems.isResourceSaved(resource) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.blue)
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .padding(12) // Padding from the top-right edges
        }
    }
}
