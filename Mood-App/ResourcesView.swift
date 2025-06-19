import SwiftUI
import UIKit

struct ResourcesView: View {
    @State private var searchText: String = ""
    @StateObject private var savedItems = SavedItems()
    @State private var navigateToSaved = false
    @FocusState private var isSearchFocused: Bool
    // Navigation state for all main screens
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false
    private let navBarHeight: CGFloat = 64

    //Defined lists containing all activities/resources of type "Activity" or "Resource"
    
    let allActivities: [Activity] = [
        Activity(name: "Go On A Walk", imageName: "resourcewalk", description: "Check out the arboretum or just head around campus!"),
        Activity(name: "Listen to Music", imageName: "resourcemusic", description: "Find a calming playlist and unwind."),
        Activity(name: "Try Meditation", imageName: "resourcemed", description: "Breathe deeply and try a guided meditation.")
    ]

    let allResources: [Resource] = [
        Resource(name: "SHCS", imageName: "cross.case.fill", description: "Check out Student Health and Counseling Services!"),
        Resource(name: "CAPS", imageName: "heart.text.clipboard", description: "Counseling and Psychological Services for support."),
        Resource(name: "Wellness Coaching", imageName: "heart.text.square.fill", description: "Meet with a coach to improve well-being.")
    ]
    
   //SearchBar: If empty: return all activities and resources, Else: Return Activities and Resources filtered by Search (not case-sensitive)
    
    var filteredActivities: [Activity] {
        if searchText.isEmpty {
            return allActivities
        } else {
            return allActivities.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var filteredResources: [Resource] {
        if searchText.isEmpty {
            return allResources
        } else {
            return allResources.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                
                // Title and Bookmark
                
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Text("Discover ways to cope.")
                            .font(.custom("Alexandria-Regular", size: 22))
                            .bold()
                            .padding(.top, 15)
                        Spacer()
                        Button {
                            navigateToSaved = true
                         } label: {
//                             Image("Bookmark Icon")
//                                .resizable()
//                                .frame(width: 30, height: 35)
//                                .padding(.top, 15)
                         }
                        Image("Bookmark Icon")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.top, 15)

                    }
                    .padding(.horizontal)

                    // Search Bar: isSearchFocused stops blinker if clicked off searchbar
                    
                    TextField("Search...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .focused($isSearchFocused)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            // Activities Section: Displaying Activities based on Filter
                            Text("Activities List")
                                .font(.custom("Alexandria-Regular", size: 17))
                                .padding(.horizontal)

                            if filteredActivities.isEmpty {
                                Text("No matching activities found.")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) { //Works by using Identifiable
                                        ForEach(filteredActivities) { activity in
                                            ActivityCard(activity: activity, savedItems: savedItems)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            // Resources Section: Displaying Resources based on Filter
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
                                            ResourceCard(resource: resource, savedItems: savedItems)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }

                }
                .onTapGesture {
                    isSearchFocused = false
                }
                VStack(spacing: 0) {
                    Spacer()
                    bottomTabBar
                }
            }
            .navigationBarBackButtonHidden(true) // Hides back button
            .gesture(DragGesture())
            .background(Color("lightd3cpurple").ignoresSafeArea())
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showPet) { PetView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .navigationDestination(isPresented: $navigateToSaved) {
                ResourcesPersonalView()
                    .environmentObject(savedItems)
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

struct ActivityCard: View {
    let activity: Activity
    @ObservedObject var savedItems: SavedItems

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Image(activity.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(10)

                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .frame(height: 100)
                    .cornerRadius(10)
            }

            Text(activity.name)
                .font(.custom("Alexandria-Regular", size: 15))
                .bold()
                .fixedSize(horizontal: false, vertical: true)

            Text(activity.description)
                .font(.custom("Alexandria-Regular", size: 12))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)

            HStack {
                Button(action: {
                    savedItems.addActivityToPlanner(activity)
                }) {
                    Text(savedItems.isActivityAdded(activity) ? "Activity Added" : "Add Activity +")
                        .font(.caption)
                        .padding(6)
                        .background(savedItems.isActivityAdded(activity) ? Color.green : Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                .disabled(savedItems.isActivityAdded(activity))


                Spacer()

                Button(action: {
                    if !savedItems.isActivitySaved(activity) {
                        savedItems.toggleActivity(activity)
                    }
                }) {
                    Image(systemName: savedItems.isActivitySaved(activity) ? "heart.fill" : "heart")
                        .foregroundColor(.blue)
                }
                .disabled(savedItems.isActivitySaved(activity)) 
                .opacity(savedItems.isActivitySaved(activity) ? 0.6 : 1.0) 

            }
        }
        .padding()
        .frame(width: 220, height: 220)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}


struct ResourceCard: View {
    let resource: Resource
    @ObservedObject var savedItems: SavedItems

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .cornerRadius(10)
                Image(systemName: resource.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .foregroundColor(.blue)
            }

            Text(resource.name)
                .font(.custom("Alexandria-Regular", size: 15))
                .bold()
                .fixedSize(horizontal: false, vertical: true)

            Text(resource.description)
                .font(.custom("Alexandria-Regular", size: 12))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)

            HStack {
                Button(action: {
                    savedItems.addResourceToPlanner(resource)
                }) {
                    Text(savedItems.isResourceAdded(resource) ? "Resource Added" : "Explore Resource")
                        .font(.caption)
                        .padding(6)
                        .background(savedItems.isResourceAdded(resource) ? Color.green : Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                .disabled(savedItems.isResourceAdded(resource))


                Spacer()

                Button(action: {
                    if !savedItems.isResourceSaved(resource) {
                        savedItems.toggleResource(resource)
                    }
                }) {
                    Image(systemName: savedItems.isResourceSaved(resource) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.blue)
                }
                .disabled(savedItems.isResourceSaved(resource)) 
                .opacity(savedItems.isResourceSaved(resource) ? 0.6 : 1.0) 
            }
        }
        .padding()
        .frame(width: 220, height: 220)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
}

#Preview {
    ResourcesView()
        .environmentObject(StoreData())
}
