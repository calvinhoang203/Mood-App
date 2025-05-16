import SwiftUI
import Combine

struct HomeView: View {
  @EnvironmentObject private var storeData: StoreData
  @EnvironmentObject private var petCustomization: PetCustomization
  @State private var tabSwitchTrigger = false

  // MARK: – Navigation State
  @State private var showPet = false
  @State private var showCheckIn = false
  @State private var showHomeNav = false
  @State private var showResource = false
  @State private var showSetGoal = false
  @State private var showAnalyticsNav = false
  @State private var showSettingNav = false
    
  // MARK: – Layout State
  @State private var editIconX: CGFloat = 0.51
  @State private var editIconY: CGFloat = 0.65
  @State private var topIconPadding: CGFloat = 70
  @State private var trailingIconPadding: CGFloat = 0

  // MARK: – Configurable Constants
  private let headerImageHeight: CGFloat = 360
  private let cowSize: CGFloat = 750
  private let editButtonSize: CGFloat = 21
  private let contentExtraOffsetY: CGFloat = 160
  private let accentColor = Color("d3cpurple")
  private let navBarHeight: CGFloat = 64

  // MARK: – Cow Position Helpers
  private var cowOffsetX: CGFloat { 160 }
  private var cowOffsetY: CGFloat { headerImageHeight - (cowSize / 3.0) }
  private var editOffsetX: CGFloat { (cowSize / 2) - (editButtonSize / 2) - 40 }
  private var editOffsetY: CGFloat { (cowSize / 2) - (editButtonSize / 2) - 15 }

  var body: some View {
    NavigationStack {
      ZStack {
        // Full-screen background
        Image("homepageview")
          .resizable()
          .scaledToFill()
          .ignoresSafeArea()

        // Scrollable content
        ScrollView(showsIndicators: false) {
          VStack(spacing: 24) {
            // ─ Cow + top icons
            ZStack {
              HStack(spacing: 6) {
                // Bookmark icon
                  NavigationLink(destination: SavedPageView()) {
                     Image("Bookmark Icon")
                       .resizable()
                       .frame(width: 40, height: 40)
                   }

                // Notification icon
                  NavigationLink(destination: NotificationView()) {
                     Image("Notification Icon")
                       .resizable()
                       .frame(width: 40, height: 40)
                   }
              }
              .padding(.top, topIconPadding)
              .padding(.trailing, trailingIconPadding)
              .frame(width: 360, alignment: .topTrailing)
            }
            .overlay(
              cowView
                .offset(x: cowOffsetX, y: cowOffsetY)
                
            )

            // ─ Remaining content
            VStack(spacing: 24) {
              Text("Welcome back, \(storeData.firstName)")
                .font(.system(size: 26, weight: .semibold))
                .frame(maxWidth: .infinity,     alignment: .leading)
                .padding(.horizontal, 16)

              quoteView
                
              Button {
                showCheckIn = true
              } label: {
                Image("Start A Check In Button")
                  .resizable()
                  .scaledToFit()
                  .frame(height: 50)
              }
              .padding(.horizontal, 32)
                
              dashboardSection
              placeholderSection
            }
            .padding(.top, contentExtraOffsetY)
          }
          .padding(.bottom, navBarHeight + 16)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            storeData.loadUserDataFromFirestore()
            petCustomization.fetchInitialCustomizations()
        }
        
        VStack {
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
      .navigationDestination(isPresented: $showCheckIn) { SurveyQuestionaireView().environmentObject(storeData) }
      .navigationBarBackButtonHidden(true)
    }
  }

    // MARK: – Cow + Edit View
    private var cowView: some View {
        ZStack {
            Group{
                // 1) Base color layer
                petCustomization.colorcow
                    .resizable()
                    .scaledToFit()
                    .frame(width: cowSize, height: cowSize)
                
                // 2) Outline
                petCustomization.outlineImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: cowSize, height: cowSize)
                
                // 3) Top accessory (only if selected)
                if !petCustomization.topName.isEmpty {
                    petCustomization.topImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: cowSize, height: cowSize)
                }
                
                // 4) Extra accessory (only if selected)
                if !petCustomization.extraName.isEmpty {
                    petCustomization.extraImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: cowSize, height: cowSize)
                }
            }
            
            .allowsHitTesting(false)

            // 5) Edit button
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
                    x: geometry.size.width * editIconX,
                    y: geometry.size.height * editIconY
                )
            }
        }
    }


  // MARK: – Quote View
  private var quoteView: some View {
    VStack(spacing: 8) {
      Text("Worrying does not take away tomorrow's troubles. It takes away today's peace.")
        .italic()
        .multilineTextAlignment(.center)
        .foregroundColor(Color("cowdarkpurple"))
      Text("– Randy Armstrong")
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .shadow(radius: 4)
    .padding(.horizontal, 16)
  }

  // MARK: – Dashboard Section
  private var dashboardSection: some View {
    VStack(spacing: 12) {
      Text("Dashboard")
        .font(.system(size: 24, weight: .semibold))
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

  // MARK: – Placeholders
  private var placeholderSection: some View {
    VStack(spacing: 20) {
      SectionHeader(title: "Activity", fontSize: 22)
        placeholderBox
      SectionHeader(title: "Resources", fontSize: 22)
        placeholderBox
      SectionHeader(title: "Your Top Moo'ds", fontSize: 22)
        placeholderBox
    }
    .padding(.horizontal, 16)
  }

  private var placeholderBox: some View {
    Rectangle()
      .fill(Color.white.opacity(0.5))
      .frame(height: 120)
      .cornerRadius(10)
  }

  // MARK: – Supplementary Views
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
    .font(.subheadline)
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
      .background(Color.white)
  }
}

// MARK: – Section Header
private struct SectionHeader: View {
  let title: String
  let fontSize: CGFloat
  var body: some View {
    HStack {
      Text(title)
        .font(.system(size: fontSize, weight: .bold))
      Spacer()
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    let demo = StoreData()
    demo.scores = ["demo": 500]
    return HomeView()
      .environmentObject(demo)
      .environmentObject(PetCustomization())
  }
}
