import SwiftUI

// FavoriteActivityCard for reusable favorite activity layout
struct FavoriteActivityCard: View {
    let activity: Activity
    @ObservedObject var savedItems: SavedItems

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .cornerRadius(10)
                Image(activity.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(10)
            }

            Text(activity.name)
                .font(.custom("Alexandria-Regular", size: 15))
                .bold()

            Text(activity.description)
                .font(.custom("Alexandria-Regular", size: 12))
                .foregroundColor(.gray)

            HStack {
                Button(action: {
                    savedItems.toggleAddedActivity(activity)
                }) {
                    Text(savedItems.isActivityAdded(activity) ? "Activity Added" : "Add Activity +")
                        .font(.custom("Alexandria-Regular", size: 12))
                        .padding(6)
                        .background(savedItems.isActivityAdded(activity) ? Color.green : Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }

                Spacer()

                Button(action: {
                    savedItems.toggleActivity(activity)
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .frame(width: 220, height: 220)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// FavoriteResourceCard for reusable favorite resource layout
struct FavoriteResourceCard: View {
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

            Text(resource.description)
                .font(.custom("Alexandria-Regular", size: 12))
                .foregroundColor(.gray)

            HStack {
                Button(action: {
                    savedItems.toggleAddedResource(resource)
                }) {
                    Text(savedItems.isResourceAdded(resource) ? "Resource Added" : "Explore Resource")
                        .font(.custom("Alexandria-Regular", size: 12))
                        .padding(6)
                        .background(savedItems.isResourceAdded(resource) ? Color.green : Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }

                Spacer()

                Button(action: {
                    savedItems.toggleResource(resource)
                }) {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .frame(width: 220, height: 220)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct ResourcesPersonalView: View {
    @EnvironmentObject var savedItems: SavedItems
    @State private var searchText: String = ""

    var body: some View {
        //Filtering by Search Bar
        let filteredSavedActivities = savedItems.savedActivities.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
        }

        let filteredSavedResources = savedItems.savedResources.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
        }

        let filteredAddedActivities = savedItems.addedActivities.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
        }

        let filteredAddedResources = savedItems.addedResources.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
        }

        VStack(alignment: .leading, spacing: 20) {
            // Top Header
            HStack {
                Text("Your Archive")
                    .font(.custom("Alexandria-Regular", size: 22))
                    .padding(.top, 15)
                    .bold()
                Spacer()
                Image(systemName: "bookmark.fill")
                Image(systemName: "bell.fill")
            }
            .padding(.horizontal)

            // Search Bar
            TextField("Search...", text: $searchText)
                .padding(10)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                .submitLabel(.done)

            ScrollView {
                VStack(alignment: .leading, spacing: 25) {

                    // Displaying Favorite Activities
                    if !filteredSavedActivities.isEmpty {
                        Text("Favorite Activities")
                            .font(.custom("Alexandria-Regular", size: 17))
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(filteredSavedActivities) { activity in
                                    FavoriteActivityCard(activity: activity, savedItems: savedItems)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Displaying Saved Resources
                    if !filteredSavedResources.isEmpty {
                        Text("Saved Resources")
                            .font(.custom("Alexandria-Regular", size: 17))
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(filteredSavedResources) { resource in
                                    FavoriteResourceCard(resource: resource, savedItems: savedItems)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Displaying Added Activities and Resources
                    if !filteredAddedActivities.isEmpty || !filteredAddedResources.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Activities and Resources")
                                .font(.custom("Alexandria-Regular", size: 17))
                                .padding(.horizontal)
                                .padding(.top, 15)
                                .padding(.bottom, 15)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(filteredAddedActivities) { activity in
                                        ActivityCard(activity: activity, savedItems: savedItems)
                                    }

                                    ForEach(filteredAddedResources) { resource in
                                        ResourceCard(resource: resource, savedItems: savedItems)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }

            homebar() // NavBar
        }
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture())
        .background(Color("lightd3cpurple").ignoresSafeArea())
    }
}
