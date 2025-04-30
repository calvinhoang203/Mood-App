import SwiftUI

struct ResourcesView: View {
    @State private var searchText: String = ""
    @StateObject private var savedItems = SavedItems()
    @State private var navigateToSaved = false

    let activities: [Activity] = [
        Activity(name: "Go On A Walk", imageName: "figure.walk", description: "Check out the arboretum or just head around campus!"),
        Activity(name: "Listen to Music", imageName: "music.note", description: "Find a calming playlist and unwind."),
        Activity(name: "Try Meditation", imageName: "brain.head.profile", description: "Breathe deeply and try a guided meditation.")
    ]

    let resources: [Resource] = [
        Resource(name: "SHCS", imageName: "cross.case.fill", description: "Check out Student Health and Counseling Services!"),
        Resource(name: "CAPS", imageName: "heart.text.clipboard", description: "Counseling and Psychological Services for support."),
        Resource(name: "Wellness Coaching", imageName: "heart.text.square.fill", description: "Meet with a coach to improve well-being.")
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("Discover ways to cope.")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button {
                        navigateToSaved = true
                    } label: {
                        Image(systemName: "bookmark.fill")
                    }
                    Image(systemName: "bell.fill")
                }
                .padding(.horizontal)

                TextField("Search...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {

                        Text("Activities For You")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(activities) { activity in
                                    ActivityCard(activity: activity, savedItems: savedItems)
                                }
                            }
                            .padding(.horizontal)
                        }

                     
                        Text("Resources for You")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(resources) { resource in
                                    ResourceCard(resource: resource, savedItems: savedItems)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }

                homebar() 
            }
            .background(Color("lightd3cpurple").ignoresSafeArea())
            .navigationDestination(isPresented: $navigateToSaved) {
                ResourcesPersonalView()
                    .environmentObject(savedItems)
            }
        }
    }
}


struct ActivityCard: View {
    let activity: Activity
    @ObservedObject var savedItems: SavedItems

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .cornerRadius(10)
                Image(systemName: activity.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .foregroundColor(.purple)
            }

            Text(activity.name)
                .font(.subheadline)
                .bold()
                .fixedSize(horizontal: false, vertical: true)

            Text(activity.description)
                .font(.caption)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

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
                .font(.subheadline)
                .bold()
                .fixedSize(horizontal: false, vertical: true)

            Text(resource.description)
                .font(.caption)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

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
