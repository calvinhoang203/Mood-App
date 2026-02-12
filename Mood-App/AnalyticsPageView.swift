//
//  AnalyticsPageView.swift
//  Mood-App
//

import SwiftUI

struct AnalyticsPageView: View {
    @EnvironmentObject var storeData: StoreData
    
    // Navigation State
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    // @State private var showAnalyticsNav = false // REMOVED: No need to navigate to self
    @State private var showSettingNav = false
    
    private let navBarHeight: CGFloat = 64
    
    // UPDATED: Max slider points set to 600
    private let maxSliderPoints: Double = 600
    private let milestoneInterval: Int = 150
    
    // Define Grid Columns (4 columns for the 4 badges)
    private let badgeColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - Grouping Logic
    var groupedSessionEntries: [MoodSession] {
        let grouped = Dictionary(grouping: storeData.moodEntries) { entry -> Date in
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: entry.date)
            return Calendar.current.date(from: components) ?? entry.date
        }
        return grouped.map { (date, entries) in
            MoodSession(date: date, entries: entries)
        }.sorted { $0.date > $1.date }
    }
    
    struct MoodSession: Identifiable {
        let id = UUID()
        let date: Date
        let entries: [MoodEntry]
        
        var distribution: [Mood: Double] {
            let total = Double(entries.count)
            guard total > 0 else { return [:] }
            var counts: [Mood: Double] = [.great: 0, .okay: 0, .meh: 0, .nsg: 0]
            for entry in entries {
                counts[entry.mood, default: 0] += 1
            }
            return counts.mapValues { $0 / total }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor").ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading) {
                        Text("Your Badges")
                            .font(.custom("Alexandria-Regular", size: 24))
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("lavenderColor"))
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            
                            // 1. Badges Grid
                            LazyVGrid(columns: badgeColumns, spacing: 20) {
                                ForEach(0..<4, id: \.self) { index in
                                    BadgeItemView(
                                        title: storeData.badgeTitles[index],
                                        imageName: "Trophy \(index + 1)",
                                        isUnlocked: storeData.unlockedBadges[index],
                                        pointsRequired: storeData.badgeScores[index]
                                    )
                                }
                            }
                            .padding(.horizontal)
                            
                            // 2. Progress Slider
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Total Progress")
                                        .font(.custom("Alexandria-Regular", size: 18))
                                        .bold()
                                    Spacer()
                                    Text("\(storeData.lifetimePoints) pts")
                                        .font(.custom("Alexandria-Regular", size: 16))
                                        .foregroundColor(.purple)
                                }
                                .padding(.horizontal)
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(height: 24)
                                    
                                    GeometryReader { geo in
                                        // Calculate fill width relative to 600 points
                                        let fillWidth = min(CGFloat(Double(storeData.lifetimePoints) / maxSliderPoints) * geo.size.width, geo.size.width)
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("d3cpurple"))
                                            .frame(width: fillWidth, height: 24)
                                    }
                                    
                                    GeometryReader { geo in
                                        HStack(spacing: 0) {
                                            // Ticks drawn based on 150 intervals up to 600
                                            ForEach(1...Int(maxSliderPoints / Double(milestoneInterval)), id: \.self) { i in
                                                let position = CGFloat(Double(i * milestoneInterval) / maxSliderPoints) * geo.size.width
                                                Rectangle()
                                                    .fill(Color.black.opacity(0.1))
                                                    .frame(width: 2, height: 16)
                                                    .offset(x: position - 1)
                                            }
                                        }
                                        .frame(height: 24)
                                    }
                                }
                                .frame(height: 24)
                                .padding(.horizontal)
                                
                                HStack {
                                    Text("0")
                                    Spacer()
                                    // FIX: Dynamically display the max value (600) instead of hardcoded "1800"
                                    Text("\(Int(maxSliderPoints))")
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            }
                            
                            // 3. Mood Legend
                            MoodLegendBox().padding(.horizontal)
                            
                            // 4. Check-In History
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Check-In History")
                                    .font(.custom("Alexandria-Regular", size: 20))
                                    .bold()
                                    .padding(.horizontal)
                                
                                ForEach(groupedSessionEntries) { session in
                                    SessionMoodSlider(session: session)
                                }
                                
                                if groupedSessionEntries.isEmpty {
                                    Text("No check-ins yet.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                }
                            }
                            Spacer(minLength: 80)
                        }
                        .padding(.top, 10)
                    }
                }
                
                // Bottom Tab Bar
                VStack(spacing: 0) {
                    Spacer()
                    bottomTabBar
                }
            }
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Components
    
    struct MoodLegendBox: View {
        let items: [(color: Color, label: String)] = [
            (Color.red.opacity(0.7), "Not so good"),
            (Color.orange.opacity(0.7), "Meh"),
            (Color.blue.opacity(0.7), "Okay"),
            (Color.green.opacity(0.7), "Great")
        ]
        var body: some View {
            HStack(spacing: 0) {
                ForEach(items, id: \.label) { item in
                    VStack(spacing: 4) {
                        Rectangle().fill(item.color).frame(height: 12)
                        Text(item.label)
                            .font(.custom("Alexandria-Regular", size: 10))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    struct SessionMoodSlider: View {
        let session: MoodSession
        private let moodOrder: [Mood] = [.nsg, .meh, .okay, .great]
        private func color(for mood: Mood) -> Color {
            switch mood {
            case .nsg: return Color.red.opacity(0.7)
            case .meh: return Color.orange.opacity(0.7)
            case .okay: return Color.blue.opacity(0.7)
            case .great: return Color.green.opacity(0.7)
            }
        }
        var dateString: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: session.date)
        }
        var timeString: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: session.date)
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(dateString)
                        .font(.custom("Alexandria-Regular", size: 14))
                        .foregroundColor(.black)
                    Spacer()
                    Text(timeString)
                        .font(.custom("Alexandria-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            ForEach(moodOrder, id: \.self) { mood in
                                let pct = session.distribution[mood] ?? 0
                                Rectangle()
                                    .fill(color(for: mood))
                                    .frame(width: geo.size.width * CGFloat(pct))
                            }
                        }
                        .cornerRadius(10)
                    }
                }
                .frame(height: 30)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal)
        }
    }
    
    // MARK: - BADGE VIEW
    struct BadgeItemView: View {
        let title: String
        let imageName: String
        let isUnlocked: Bool
        let pointsRequired: Int
        
        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .fill(isUnlocked ? Color("d3cpurple") : Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .shadow(radius: isUnlocked ? 3 : 0)
                    
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .opacity(isUnlocked ? 1.0 : 0.2)
                        .grayscale(isUnlocked ? 0.0 : 1.0)
                    
                    if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                            .font(.caption)
                            .shadow(radius: 1)
                    }
                }
                
                Text(title)
                    .font(.caption)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(width: 70)
                    .lineLimit(2)
                
                if !isUnlocked {
                    Text("\(pointsRequired) pts")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    // MARK: - Bottom Tab Bar
    private var bottomTabBar: some View {
        HStack {
            Spacer()
            Button { withAnimation(.none) { showHomeNav = true } } label: {
                Image("Home Button").resizable().aspectRatio(contentMode: .fit).frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showResource = true } } label: {
                Image("Resource Button").resizable().aspectRatio(contentMode: .fit).frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showSetGoal = true } } label: {
                Image("Set Goal Button").resizable().aspectRatio(contentMode: .fit).frame(width: 36, height: 36)
            }
            Spacer()
            // Disabled Analytics Button
            Button { } label: {
                Image("Analytics Button").resizable().aspectRatio(contentMode: .fit).frame(width: 36, height: 36).opacity(1.0)
            }
            Spacer()
            Button { withAnimation(.none) { showSettingNav = true } } label: {
                Image("Setting Button").resizable().aspectRatio(contentMode: .fit).frame(width: 36, height: 36)
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

struct AnalyticsPageView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsPageView()
            .environmentObject(StoreData.demo)
    }
}
