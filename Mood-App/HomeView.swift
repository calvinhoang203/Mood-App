//
//  HomeView.swift
//  MoodApp
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserProfile: Codable {
    let firebase_uid: String
    let email: String
    let name: String
}

struct HomeView: View {
  @EnvironmentObject private var storeData       : StoreData
  @EnvironmentObject private var petCustomization: PetCustomization

  @State private var userProfile: UserProfile?
  @State private var isLoadingProfile = false

  // MARK: – Configurable Constants

  /// Height of the top “hero” image
  private let headerImageHeight: CGFloat = 360

  /// Overall cow width/height
  private let cowSize:           CGFloat = 400   // ← bump this to grow/shrink cow

  /// Size of the edit-pencil button
  private let editButtonSize:    CGFloat = 28

  /// How much to shift *all* content down under the cow
  /// ↑ ↑ ↑  Tweak this when you change `cowSize`  ↑ ↑ ↑
  private let contentExtraOffsetY: CGFloat = 140

  /// Deep-purple accent color
  private let accentColor       = Color("d3cpurple")

  /// Your target point total
  private let goalPoints        = 300

  /// Bottom tab-bar height
  private let navBarHeight:      CGFloat = 64

  // MARK: – Cow Position Helpers

  /// Move the cow **left/right** (negative = left, positive = right)
  private var cowOffsetX: CGFloat {
    150   // ← push positive to slide cow farther right
  }

  /// Move the cow **up/down** (hero bottom is y==0)
  private var cowOffsetY: CGFloat {
    headerImageHeight - (cowSize / 2)
  }

  /// Pencil offset from the cow’s bottom-right corner
  private var editOffsetX: CGFloat {
    (cowSize / 2) - (editButtonSize / 2) - 40
    // ↑ tweak “-16” to slide pencil closer/further into cow’s corner
  }
  private var editOffsetY: CGFloat {
    (cowSize / 2) - (editButtonSize / 2) - 16
  }

  var body: some View {
    NavigationStack {
      ZStack {
        // ─── 1) Full-screen background image ───
        Image("homepageview")
          .resizable()
          .scaledToFill()
          .ignoresSafeArea()

        // ─── 2) Scrolling content ───
        ScrollView(showsIndicators: false) {
          VStack(spacing: 24) {
            // ─ Cow + pencil overlaps the hero area
            ZStack(alignment: .topTrailing) {
              Color.clear.frame(height: headerImageHeight)

              cowView
                .offset(x: cowOffsetX,
                        y: cowOffsetY)
            }

            // ─ Remaining content ─
            VStack(spacing: 24) {
              // 3) Greeting
              Text("Welcome back, \(userProfile?.name ?? "")")
                .font(.system(size: 28, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

              // 4) Quote
              VStack(spacing: 8) {
                Text("“Worrying does not take away tomorrow’s troubles. It takes away today’s peace.”")
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

              // 5) Dashboard
              dashboardSection

              // 6) Placeholders
              placeholderSection
            }
          }
          // pull content up *half* the cow, then drop everything by contentExtraOffsetY
          .padding(.top, -cowSize / 2 + contentExtraOffsetY)
          .padding(.bottom, navBarHeight + 16)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear(perform: loadProfile)

        // ─── 7) Fixed bottom bar ───
        VStack {
          Spacer()
          bottomTabBar
        }
      }
    }
  }

  // MARK: – Cow + Edit View

  private var cowView: some View {
    ZStack {
      Image("OUTLINE")
        .resizable().scaledToFit()
        .frame(width: cowSize, height: cowSize)

      petCustomization.colorcow
        .resizable().scaledToFit()
        .frame(width: cowSize, height: cowSize)
      petCustomization.topImage
        .resizable().scaledToFit()
        .frame(width: cowSize, height: cowSize)
      petCustomization.extraImage
        .resizable().scaledToFit()
        .frame(width: cowSize, height: cowSize)

      NavigationLink(destination: PetView()) {
        Image("Edit Icon")
          .resizable()
          .frame(width: editButtonSize, height: editButtonSize)
          .padding(6)
          .background(Color.white.opacity(0.9))
          .clipShape(Circle())
          .shadow(radius: 2)
      }
      .offset(x: editOffsetX,
              y: editOffsetY)
    }
  }

  // MARK: – Dashboard Section

  private var dashboardSection: some View {
    VStack(spacing: 12) {
      Text("Dashboard")
        .font(.system(size: 22, weight: .bold))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)

      HStack {
        // ring
        ZStack {
          Circle()
            .stroke(Color.gray.opacity(0.3), lineWidth: 12)
            .frame(width: 100, height: 100)
          let total = storeData.scores.values.reduce(0, +)
          Circle()
            .trim(from: 0, to: CGFloat(total) / CGFloat(goalPoints))
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

        // centered text
        let remaining = max(goalPoints - storeData.scores.values.reduce(0,+), 0)
        (
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
      .padding()
      .background(Color.white)
      .cornerRadius(12)
      .shadow(radius: 4)
      .padding(.horizontal, 16)

      NavigationLink(destination: SetGoalView()) {
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
      SectionHeader(title: "Activity",    fontSize: 22)
      placeholderBox
      SectionHeader(title: "Resources",   fontSize: 22)
      placeholderBox
      SectionHeader(title: "Your Top Moo’ds", fontSize: 22)
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

  // MARK: – Bottom Tab Bar

  private var bottomTabBar: some View {
    HStack {
      Spacer(); navButton("Home Button",     HomeView());     Spacer()
      navButton("Resource Button", ResourcesView()); Spacer()
      navButton("Set Goal Button", SetGoalView());   Spacer()
      navButton("Analytics Button", AnalyticsPageView()); Spacer()
      navButton("Setting Button",  SettingView());   Spacer()
    }
    .frame(height: navBarHeight)
    .background(Color.white.opacity(0.9))
  }

  private func navButton<Dest: View>(_ image: String, _ dest: Dest) -> some View {
    NavigationLink(destination: dest) {
      Image(image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 36, height: 36)
    }
  }

  // MARK: – Firestore Load

  private func loadProfile() {
    guard !isLoadingProfile,
          userProfile == nil,
          let uid = Auth.auth().currentUser?.uid
    else { return }
    isLoadingProfile = true

    Firestore.firestore()
      .collection("users")
      .document(uid)
      .getDocument { snap, err in
        defer { isLoadingProfile = false }
        guard err == nil,
              let data = snap?.data(),
              let name = data["name"] as? String,
              let email = data["email"] as? String
        else { return }
        userProfile = UserProfile(firebase_uid: uid,
                                  email: email,
                                  name: name)
      }
  }
}

private struct SectionHeader: View {
  let title: String
  let fontSize: CGFloat
  init(title: String, fontSize: CGFloat = 20) {
    self.title = title
    self.fontSize = fontSize
  }
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
    demo.scores = ["demo": 217]
    return HomeView()
      .environmentObject(demo)
      .environmentObject(PetCustomization())
  }
}
