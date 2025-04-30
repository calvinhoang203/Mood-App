import SwiftUI

struct ResourcesPersonalView: View {
    @EnvironmentObject var savedItems: SavedItems
    @State private var searchText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Top Header
            HStack {
                Text("Your Archive")
                    .font(.title2)
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

            ScrollView {
                VStack(alignment: .leading, spacing: 25) {

                    // Favorite Activities
                    if !savedItems.savedActivities.isEmpty {
                        Text("Favorite Activities")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(savedItems.savedActivities) { activity in
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

                                        Text(activity.description)
                                            .font(.caption)
                                            .foregroundColor(.gray)

                                        HStack {
                                            Button("Add Activity +") {}
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.purple)
                                                .foregroundColor(.white)
                                                .cornerRadius(6)

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
                            .padding(.horizontal)
                        }
                    }

                    // Saved Resources
                    if !savedItems.savedResources.isEmpty {
                        Text("Saved Resources")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(savedItems.savedResources) { resource in
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

                                        Text(resource.description)
                                            .font(.caption)
                                            .foregroundColor(.gray)

                                        HStack {
                                            Button("Explore Resource") {}
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.purple)
                                                .foregroundColor(.white)
                                                .cornerRadius(6)

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
                            .padding(.horizontal)
                        }
                    }

                }
                .padding(.top, 10)
                // Your Activities and Resources
                if !savedItems.addedActivities.isEmpty || !savedItems.addedResources.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Activities and Resources")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 15)
                            .padding(.bottom, 15)



                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(savedItems.addedActivities) { activity in
                                    ActivityCard(activity: activity, savedItems: savedItems)
                                }

                                ForEach(savedItems.addedResources) { resource in
                                    ResourceCard(resource: resource, savedItems: savedItems)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }


            }

            homebar() // Optional bottom tab
        }
        .background(Color("lightd3cpurple").ignoresSafeArea())
    }
}
