import SwiftUI

struct PetView: View {
    // Shared customization data (from PetCustomization.swift)
    @EnvironmentObject var petCustomization: PetCustomization
    // Shared points/state for unlocking items (from StoreData.swift)
    @EnvironmentObject var storeData: StoreData
    
    // MARK: — View State
    /// Currently selected tab: "Colors", "Tops", or "Extras"
    @State private var selectedTab = "Colors"
    /// Controls display of "Not enough points" alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // MARK: — UI Configuration
    /// Tab titles
    private let tabs = ["Colors", "Tops", "Extras"]
    // Item costs
    private let colorCost = 50
    private let topCost = 50
    private let extraCost = 50
    
    // ─── Colors Data ─────────────────────────────────────────────────────────
    /// Image names for thumbnails
    private let colorOptions = [
        "displayblue", "displaydarkpurple", "displaygreen",
        "displaylightgreen", "displaypeach", "displaypink",
        "displaypurple", "displayred", "displayyellow"
    ]
    /// Actual cow color asset names
    private let colorImages = [
        "bluecow", "darkpurplecow", "darkgreencow",
        "lightgreencow", "peachcow", "pinkcow",
        "purplecow", "redcow", "yellowcow"
    ]
    /// User-friendly names under each thumbnail
    private let colorNames = [
        "Blue", "Dark Purple", "Dark Green",
        "Light Green", "Peach", "Pink",
        "Purple", "Red", "Yellow"
    ]
    
    // ─── Tops Data ────────────────────────────────────────────────────────────
    private let topImages = ["tophat", "hoodie", "bowtie"]
    private let topNames = ["Top Hat", "Hoodie", "Bow Tie"]
    
    // ─── Extras Data ──────────────────────────────────────────────────────────
    private let extraDisplayImages = [
        "earingview", "glassesview", "hatview",
        "necklaceview", "videogameview", "basketballview",
        "bowview", "bobaview", "pantsview",
        "maskview", "airpodsview"
    ]
    private let extraImages = [
        "earing", "glasses", "hat",
        "necklace", "videogame", "basketball",
        "bow", "boba", "pants",
        "mask", "airpods"
    ]
    private let extraNames = [
        "Earring", "Glasses", "Hat",
        "Necklace", "Video Game", "Basketball",
        "Bow", "Boba", "Pants",
        "Mask", "AirPods"
    ]
    
    // Add these @State variables at the top of PetView (inside the struct, before body):
    @State private var cowColorWidth: CGFloat = 800
    @State private var cowColorHeight: CGFloat = 800

    @State private var cowColorX: CGFloat = 290
    @State private var cowColorY: CGFloat = 80

    @State private var cowOutlineWidth: CGFloat = 800
    @State private var cowOutlineHeight: CGFloat = 800
    @State private var cowOutlineX: CGFloat = 290
    @State private var cowOutlineY: CGFloat = 80


    @State private var cowTopWidth: CGFloat = 350
    @State private var cowTopHeight: CGFloat = 350
    @State private var cowTopX: CGFloat = 200
    @State private var cowTopY: CGFloat = 120

    @State private var cowExtraWidth: CGFloat = 350
    @State private var cowExtraHeight: CGFloat = 350
    @State private var cowExtraX: CGFloat = 200
    @State private var cowExtraY: CGFloat = 120
    
    // Navigation state for all main screens
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false
    private let navBarHeight: CGFloat = 64
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color("lightd3cpurple")
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack(spacing: 12) {
                        // Points Display
                        HStack {
                            Text("Points: \(storeData.totalPoints)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color("d3cpurple"))
                                .cornerRadius(8)
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack {
                            Text("Your Avatar")
                                .font(.custom("Alexandria-Regular", size: 30))
                                .font(.headline)
                                .padding(.leading, 30)
                                .padding(.top, 15)
                            Spacer()
                        }
                        Spacer()
                        
                        // ─── Cow Display ─────────────────────────────────────────────
                        ZStack {
                            let posX = geometry.size.width / 1.57
                            let posY = geometry.size.height * 0.125

                            // Shadow ellipse behind the cow
                            Ellipse()
                                .fill(Color("d3cpurple"))
                                .frame(width: 250, height: 70)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 9, x: 5, y: 5)
                                .position(x: posX * 0.8, y: posY * 2)

                            petCustomization.colorcow
                                .resizable()
                                .scaledToFit()
                                .frame(width: cowColorWidth, height: cowColorHeight)
                                .position(x: cowColorX, y: cowColorY)

                            petCustomization.outlineImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: cowOutlineWidth, height: cowOutlineHeight)
                                .position(x: cowOutlineX, y: cowOutlineY)

                            if !petCustomization.topName.isEmpty {
                                petCustomization.topImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cowColorWidth, height: cowColorHeight)
                                    .position(x: cowColorX, y: cowColorY)
                            }

                            if !petCustomization.extraName.isEmpty {
                                petCustomization.extraImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cowColorWidth, height: cowColorHeight)
                                    .position(x: cowColorX, y: cowColorY)
                            }
                        }

                        
                        // ─── Tab Selector ──────────────────────────────────────────────
                        HStack(spacing: 12) {
                            ForEach(tabs, id: \.self) { tab in
                                Button(action: {
                                    selectedTab = tab
                                }) {
                                    Text(tab)
                                        .fontWeight(selectedTab == tab ? .bold : .regular)
                                        .foregroundColor(selectedTab == tab ? .white : .gray)
                                        .padding()
                                        .background(selectedTab == tab ? Color("d3cpurple") : Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .font(.custom("Alexandria-Regular", size: 15))
                                }
                            }
                        }
                        .padding(.vertical)
                        
                        // ─── Customization Grid ────────────────────────────────────────
                        ScrollView {
                            if selectedTab == "Colors" {
                                itemGrid(
                                    display: colorOptions,
                                    items: colorImages,
                                    names: colorNames,
                                    geometry: geometry
                                ) { index in
                                    let name = colorImages[index]
                                    if petCustomization.unlockedItems.contains(name) {
                                        petCustomization.updateColor(name)
                                    }
                                }
                            }
                            else if selectedTab == "Tops" {
                                itemGrid(
                                    display: topImages,
                                    items: topImages,
                                    names: topNames,
                                    geometry: geometry
                                ) { index in
                                    let name = topImages[index]
                                    if petCustomization.unlockedItems.contains(name) {
                                        petCustomization.updateTop(name)
                                    }
                                }
                            }
                            else {
                                itemGrid(
                                    display: extraDisplayImages,
                                    items: extraImages,
                                    names: extraNames,
                                    geometry: geometry
                                ) { index in
                                    let name = extraImages[index]
                                    if petCustomization.unlockedItems.contains(name) {
                                        petCustomization.updateExtra(name)
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                VStack {
                    Spacer()
                    bottomTabBar
                }
            }
            
            .onAppear {
                petCustomization.fetchInitialCustomizations()
            }
            .onChange(of: showAlert) { _ in petCustomization.fetchInitialCustomizations() }
            
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showPet) { PetView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .navigationBarBackButtonHidden(true)
        }
        .onDisappear {
            // Force reload from Firestore when leaving PetView
            petCustomization.fetchInitialCustomizations()
        }
    }
    // ─── Grid Builder ────────────────────────────────────────────────────────
    // Creates a 3-column grid of thumbnails with lock/unlock buttons.
    private func itemGrid(
        display: [String],
        items: [String],
        names: [String],
        geometry: GeometryProxy,
        action: @escaping (Int) -> Void
    ) -> some View {
        // Determine cost for this category
        let cost: Int =
            items == colorImages ? colorCost :
            items == topImages ? topCost :
            items == extraImages ? extraCost : 50
        return LazyVGrid(
            columns: Array(repeating: .init(.flexible(), spacing: 10), count: 3),
            spacing: 15
        ) {
            ForEach(items.indices, id: \.self) { index in
                VStack(spacing: 6) {
                    ZStack {
                        // Ellipse base under each item
                        Ellipse()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: geometry.size.width * 0.20, height: geometry.size.width * 0.05)
                            .offset(y: geometry.size.width * 0.065)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                        // Item image
                        Image(display[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                if petCustomization.unlockedItems.contains(items[index]) {
                                    action(index)
                                }
                            }
                            .padding(.top, 15)
                    }
                    // Item name
                    Text(names[index])
                        .font(.caption)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    // Cost label
                    Text("\(cost) pts")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    // Lock/Unlock button
                    Button {
                        if !petCustomization.unlockedItems.contains(items[index]) {
                            petCustomization.unlockItem(items[index], storeData: storeData) { success in
                                if !success {
                                    alertMessage = "You need \(cost) points to unlock this item."
                                    showAlert = true
                                }
                            }
                        }
                    } label: {
                        Text(petCustomization.unlockedItems.contains(items[index]) ? "Unlocked" : "Locked")
                            .font(.custom("Jua", size: 14))
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .background(
                                petCustomization.unlockedItems.contains(items[index])
                                ? Color.green
                                : Color.red
                            )
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            }
        }
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
            Button { withAnimation(.none) { showPet = true } } label: {
                Image("Pet Button")
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

// ─── Preview ──────────────────────────────────────────────────────────────
struct PetView_Previews: PreviewProvider {
    static var previews: some View {
        PetView()
            .environmentObject(StoreData())
            .environmentObject(PetCustomization())
    }
}
