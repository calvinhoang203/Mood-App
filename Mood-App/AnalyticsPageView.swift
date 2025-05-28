//
//  AnalyticsPageView.swift
//  Mood-App
//
//  Created by Hieu Hoang on 4/29/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UIKit

struct AnalyticsPageView: View {
    @EnvironmentObject var storeData: StoreData
    @State private var showHomeNav      = false
    @State private var showResource     = false
    @State private var showSetGoal      = false
    @State private var showAnalyticsNav = false
    @State private var showPet          = false
    @State private var showSettingNav   = false
    
    /// Midnight Purple (#463F6D) for the streak text
    private let streakTextColor = Color("cowdarkpurple")
    /// Days required for a full streak bar
    private let maxStreakDays = 7
    /// Bottom tab-bar height
    private let navBarHeight: CGFloat = 64

    /// 0…1 fraction of streak progress
    private var streakFraction: CGFloat {
        guard maxStreakDays > 0 else { return 0 }
        return min(CGFloat(storeData.currentStreak) / CGFloat(maxStreakDays), 1)
    }
    
    // Get all emotions for the legend
    private var allEmotions: [Emotion] {
        [.great, .okay, .meh, .nsg]
    }

    /// Per‐badge lock offsets in case you need to tweak
    private let lockOffsets: [CGSize] = [.zero, .zero, .zero, .zero]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lavenderColor").ignoresSafeArea()

                // ─── Main scroll content ───────────────────────────────
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {

                        topNav
                        cowIllustration
                        streakView
                        badgesView
                        weeklyStatsView

                        Spacer(minLength: 32)
                    }
                    .padding(.vertical, 16)
                    .padding(.bottom, navBarHeight)
                }
                VStack(spacing: 0) {
                    Spacer()
                    bottomTabBar
                }
            }
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showPet) { PetView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .onAppear { 
                storeData.fetchAnalyticsData() 
                print("Analytics page appeared, fetching data")
                print("Current mood distribution: \(storeData.weeklyMoodDistribution)")
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: – Top Nav

    private var topNav: some View {
        HStack {
            Text("Analytics")
                .font(.custom("Alexandria-Regular", size: 26))
            Spacer()
//            NavigationLink(destination: SavedPageView()) {
//                Image("Bookmark Icon")
//                    .resizable()
//                    .frame(width: 36, height: 36)
//            }
            NavigationLink(destination: NotificationView()) {
                Image("Notification Icon")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: – Cow Illustration

    private var cowIllustration: some View {
        HStack(spacing: 0) {
            Image("Analytics Icon")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .rotationEffect(.degrees(-15))
                .offset(x: -20)
            Image("Analytics Icon")
                .resizable()
                .scaledToFit()
                .frame(height: 140)
            Image("Analytics Icon")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .rotationEffect(.degrees(15))
                .offset(x: 20)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: – Streak View

    private var streakView: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white)
                    .frame(height: 14)

                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#FFD117"),
                                Color(hex: "#FAA747")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: (UIScreen.main.bounds.width - 32) * streakFraction,
                        height: 14
                    )
            }
            .cornerRadius(7)

            Text("\(storeData.currentStreak) DAY STREAK")
                .font(.custom("Alexandria-Regular", size: 20).weight(.bold))
                .foregroundColor(streakTextColor)
        }
        .padding(.horizontal, 16)
    }

    // MARK: – Badges View

    private var badgesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Badges")
                .font(.custom("Alexandria-Regular", size: 22).weight(.bold))
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    ForEach(0..<storeData.badgeTitles.count, id: \.self) { i in
                        let unlocked = storeData.unlockedBadges[i]
                        VStack(spacing: 8) {
                            ZStack {
                                Image("Trophy \(i+1)")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        unlocked
                                            ? nil
                                            : Color.black.opacity(0.3)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                    )

                                if !unlocked {
                                    Image("Lock Icon")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .offset(lockOffsets[i])
                                }
                            }
                                .font(.custom("Alexandria-Regular", size: 13))
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: – Weekly Stats View

    private var weeklyStatsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Weekly Stats")
                .font(.custom("Alexandria-Regular", size: 22).weight(.bold))
                .padding(.horizontal, 16)

            if storeData.weeklyMoodDistributions.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(radius: 4)
                        .frame(maxWidth: .infinity, minHeight: 320, maxHeight: 350)
                    Text("No mood data yet")
                        .font(.custom("Alexandria-Regular", size: 17))
                        .foregroundColor(.gray)
                }
            } else {
                TabView {
                    ForEach(Array(storeData.weeklyMoodDistributions.enumerated()), id: \ .offset) { item in
                        let week = item.element
                        VStack(spacing: 12) {
                            Spacer(minLength: 8)
                            DonutChart(data: week.1, weekStart: week.0)
                                .frame(width: 160, height: 160)
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, minHeight: 320, maxHeight: 350)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(radius: 4)
                        )
                        .padding(.horizontal, 32)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 350)
            }
        }
    }

    // Helper for formatting the week start date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
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

// MARK: – Preview

struct AnalyticsPageView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsPageView()
            .environmentObject(StoreData.demo)
    }
}
