//
//  AnalyticsPageView.swift
//  Mood-App
//
//  Created by Hieu Hoang on 4/29/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AnalyticsPageView: View {
    @EnvironmentObject var storeData: StoreData
    @State private var showHomeNav      = false
    @State private var showResource     = false
    @State private var showSetGoal      = false
    @State private var showAnalyticsNav = false
    @State private var showSettingNav   = false
    
    /// Midnight Purple (#463F6D) for the streak text
    private let streakTextColor = Color("cowdarkpurple")
    /// Days required for a full streak bar
    private let maxStreakDays = 7
    /// Bottom tab-bar height
    private let navBarHeight: CGFloat = 50

    /// 0…1 fraction of streak progress
    private var streakFraction: CGFloat {
        guard maxStreakDays > 0 else { return 0 }
        return min(CGFloat(storeData.currentStreak) / CGFloat(maxStreakDays), 1)
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

                // ─── Fixed bottom tab bar ──────────────────────────────
                VStack {
                    Spacer()
                    bottomTabBar
                }
            }
            .onAppear { storeData.fetchAnalyticsData() }
            
        }
        .navigationDestination(isPresented: $showHomeNav)      { HomeView() }
        .navigationDestination(isPresented: $showResource)     { ResourcesView() }
        .navigationDestination(isPresented: $showSetGoal)      { SetGoalView() }
        .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
        .navigationDestination(isPresented: $showSettingNav)   { SettingView() }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: – Top Nav

    private var topNav: some View {
        HStack {
            Text("Analytics")
                .font(.system(size: 26, weight: .bold))
            Spacer()
            NavigationLink(destination: SavedPageView()) {
                Image("Bookmark Icon")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
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
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(streakTextColor)
        }
        .padding(.horizontal, 16)
    }

    // MARK: – Badges View

    private var badgesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Badges")
                .font(.system(size: 22, weight: .bold))
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
//                            Text(storeData.badgeTitles[safe: i] ?? "")
                                .font(.footnote)
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
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 16)

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 4)
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)

                VStack(spacing: 8) {
                    Spacer()
//                    DonutChart(data: storeData.weeklyMoodData)
//                        .frame(width: 150, height: 150)

                    Text(storeData.weekRangeText.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: – Bottom Tab Bar

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
        .background(Color.white)
    }

    private func navButton<Dest: View>(_ image: String, _ dest: Dest) -> some View {
        NavigationLink(destination: dest) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
        }
    }
}


// MARK: – DonutChart Support

//struct DonutSegment: Shape {
//    var startAngle: Angle, endAngle: Angle
//    func path(in rect: CGRect) -> Path {
//        var p = Path()
//        let r = min(rect.width, rect.height) / 2
//        let c = CGPoint(x: rect.midX, y: rect.midY)
//        p.addArc(center: c,
//                 radius: r,
//                 startAngle: startAngle - .degrees(90),
//                 endAngle:   endAngle   - .degrees(90),
//                 clockwise: false)
//        return p.strokedPath(.init(lineWidth: r * 0.4, lineCap: .butt))
//    }
//}

//struct DonutChart: View {
//    let data: [String: Double]
//    private var total: Double { data.values.reduce(0, +) }
//    private var segments: [(Color, Angle, Angle, String)] {
//        var res: [(Color,Angle,Angle,String)] = []
//        var start = Angle.degrees(0)
//        for (cat, val) in data {
//            let end = start + .degrees((val / total) * 360)
////            let col: Color = {
////                switch cat {
////                case "Happiness": return Color(hex: "#FFCE9A")
////                case "Sadness":    return Color(hex: "#4A90E2")
////                case "Anxiety":    return Color(hex: "#B8E7A6")
////                default:           return .gray
////                }
////            }()
////            res.append((col, start, end, cat))
//            start = end
//        }
//        return res
//    }

//    var body: some View {
//        ZStack {
//            ForEach(0..<segments.count, id: \.self) { i in
//                DonutSegment(startAngle: segments[i].1,
//                             endAngle:   segments[i].2)
//                    .fill(segments[i].0)
//            }
//            ForEach(segments, id: \.3) { seg in
//                let mid = (seg.1 + seg.2) / 2
//                let rad = 75 * 0.75
//                let x = cos(mid.radians) * rad + 75
//                let y = sin(mid.radians) * rad + 75
//                Text(seg.3)
//                    .font(.caption2)
//                    .position(x: x, y: y)
//            }
//        }
//    }
//}


// MARK: – Safe Array Indexing

//extension Collection {
//    subscript(safe i: Index) -> Element? {
//        indices.contains(i) ? self[i] : nil
//    }
//}


// MARK: – Preview

struct AnalyticsPageView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsPageView()
            .environmentObject(StoreData.demo)
    }
}
