// ResourcesPersonalView.swift
/*
import SwiftUI

struct ResourcesPersonalView: View {
    @EnvironmentObject var savedItems: SavedItems
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your Activities and Resources")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)

                    if savedItems.addedActivities.isEmpty && savedItems.addedResources.isEmpty {
                        Text("You haven't added any activities or resources yet.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        if !savedItems.addedActivities.isEmpty {
                            SectionView(title: "Your Activities") {
                                ForEach(savedItems.addedActivities) { activity in
                                    ActivityCard(activity: activity, topTags: [], savedItems: savedItems)
                                }
                            }
                        }
                        
                        if !savedItems.addedResources.isEmpty {
                            SectionView(title: "Your Resources") {
                                ForEach(savedItems.addedResources) { resource in
                                    ResourceCard(resource: resource, topTags: [], savedItems: savedItems)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Saved")
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    content()
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
    }
}

struct ResourcesPersonalView_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesPersonalView()
            .environmentObject(SavedItems())
    }
}

*/
