import SwiftUI
import Combine
import UIKit

// Custom shape for rounded corners
struct HomeCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct HomeView: View {
    @EnvironmentObject var savedItems: SavedItems
    @EnvironmentObject private var storeData: StoreData
    @EnvironmentObject private var petCustomization: PetCustomization
    @State private var tabSwitchTrigger = false

    private let topTags: [String] = ["exercise", "happy", "peaceful"]

    // Navigation state
    @State private var showPet = false
    @State private var showCheckIn = false
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showSettingNav = false
    
    // Alert state for check-in limit
    @State private var showLimitAlert = false

    // Layout constants
    private let headerImageHeight: CGFloat = 360
    private let cowSize: CGFloat = 750
    private let editButtonSize: CGFloat = 21
    private let contentExtraOffsetY: CGFloat = 20
    private let accentColor = Color("d3cpurple")
    private let navBarHeight: CGFloat = 64

    private var cowOffsetX: CGFloat { 160 }
    private var cowOffsetY: CGFloat { headerImageHeight - (cowSize / 3.0) }

    var body: some View {
        NavigationStack {
            ZStack {
                Image("homepageview")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    
                    // MARK: - HEADER SECTION
                ZStack {
                    HStack(spacing: 6) {

                        // MARK: - BOOKMARK BUTTON

                        // This simply toggles the state. The destination is handled at the bottom.

                        Image(storeData.dominantMoodIcon)
                            .resizable()
                            .frame(width: 40, height: 40)
                        /*Button {

                            showNotification = true

                        } label: {

                            Image(storeData.dominantMoodIcon)

                                .resizable()

                                .frame(width: 40, height: 40)

                        } */
                    }
                    .padding(.top, 75)
                    .padding(.trailing, 0)
                    .frame(width: 360, alignment: .topTrailing)
                }
               .overlay(
                    cowView
                        .offset(x: cowOffsetX, y: cowOffsetY)

                )

                    // MARK: - CONTENT SECTION
                    VStack {
                        ZStack {
                            VStack {
                                Text("Welcome back, \(storeData.firstName)")
                                    .font(.custom("Alexandria-Regular", size: 26))
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                            }
                            .safeAreaInset(edge: .top) {
                                Color.clear.frame(height: 25)
                            }
                        }
                        .padding(.top, 150)

                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 40) {
                                VStack(spacing: 10) {
                                    quoteView

                                    // Check-In Button with Limit Logic
                                    Button {
                                        showCheckIn = true
                                    } label: {
                                        Image("Start A Check In Button")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 50)
                                    }
                                    .padding(.horizontal, 32)
                                }

                                dashboardSection

                                // Liked Activities
                                VStack(spacing: 24) {
                                    Text("Liked Activities")
                                        .font(.custom("Alexandria-Regular", size: 22))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 16)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(savedItems.savedActivities) { activity in
                                                ActivityCard(activity: activity, topTags: topTags)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }

                                // Saved Resources
                                VStack(spacing: 24) {
                                    Text("Saved Resources")
                                        .font(.custom("Alexandria-Regular", size: 22))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 16)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            ForEach(savedItems.savedResources) { resource in
                                                ResourceCard(resource: resource, topTags: topTags)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.top, contentExtraOffsetY)
                        }
                    }
                    .padding(.bottom, navBarHeight + 16)
                }
                .ignoresSafeArea(edges: .top)
                .onAppear {
                    storeData.loadUserDataFromFirestore()
                    petCustomization.fetchInitialCustomizations()
                }

                VStack(spacing: 0) {
                    Spacer()
                    bottomTabBar
                }
            }
            .navigationDestination(isPresented: $showHomeNav) {
                HomeView()
                    .environmentObject(storeData)
                    .environmentObject(petCustomization)
                    .environmentObject(savedItems)
            }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showPet) { PetView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .navigationDestination(isPresented: $showCheckIn) { SurveyQuestionaireView().environmentObject(storeData) }
            .navigationBarBackButtonHidden(true)
        }
    }

    private var cowView: some View {
        ZStack {
            Group {
                petCustomization.colorcow
                    .resizable()
                    .scaledToFit()
                    .frame(width: cowSize, height: cowSize)

                petCustomization.outlineImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: cowSize, height: cowSize)
                
                petCustomization.pantsImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: cowSize, height: cowSize)

                petCustomization.topImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: cowSize, height: cowSize)
                
                petCustomization.extraImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: cowSize, height: cowSize)
            }
            .allowsHitTesting(false)

            GeometryReader { geometry in
                Button {
                    showPet = true
                } label: {
                    Image("Edit Icon")
                        .resizable()
                        .frame(width: editButtonSize, height: editButtonSize)
                        .padding(editButtonSize / 4)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .position(
                    x: geometry.size.width * 0.51,
                    y: geometry.size.height * 0.65
                )
            }
        }
    }

    private var quoteView: some View {
        VStack(spacing: 8) {
            Text(storeData.customQuote)
                .font(.custom("Alexandria-Regular", size: 16))
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(Color("cowdarkpurple"))
                .minimumScaleFactor(0.9) // Scales down slightly if text is very long

            Text("~ \(storeData.firstName) \(storeData.lastName)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        // UPDATED: Fixed frame height
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal, 16)
    }

    private var dashboardSection: some View {
        VStack(spacing: 12) {
            Text("Dashboard")
                .font(.custom("Alexandria-Regular", size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            HStack {
                ringGauge
                remainingPointsText
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
            .padding(.horizontal, 16)

            Button {
                showSetGoal = true
            } label: {
                Image("Set New Goal Button")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            }
            .padding(.horizontal, 32)
        }
    }

    private var ringGauge: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                .frame(width: 100, height: 100)

            let total = storeData.totalPoints
            Circle()
                .trim(from: 0, to: CGFloat(total) / CGFloat(storeData.goalPoints))
                .stroke(accentColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 100, height: 100)

            VStack {
                Text("\(total)")
                    .font(.title3.bold())
                Text("pts")
                    .font(.caption)
            }
        }
    }

    private var remainingPointsText: some View {
        let total = storeData.totalPoints
        let remaining = max(storeData.goalPoints - total, 0)
        return (
            Text("You are ")
            + Text("\(remaining)")
                .foregroundColor(accentColor)
                .fontWeight(.bold)
            + Text(" points away from your goal.")
        )
        .font(.custom("Alexandria-Regular", size: 15))
        .frame(maxWidth: .infinity, alignment: .center)
        .multilineTextAlignment(.center)
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
        .padding(.bottom, 8)
        .background(
            Color.white
                .clipShape(HomeCornerShape(radius: 30, corners: [.topLeft, .topRight]))
                .edgesIgnoringSafeArea(.bottom)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -2)
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let demo = StoreData()
        demo.scores = ["demo": 500]
        return HomeView()
            .environmentObject(demo)
            .environmentObject(PetCustomization())
            .environmentObject(SavedItems())
    }
}
