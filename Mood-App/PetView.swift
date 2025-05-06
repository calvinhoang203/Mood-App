import SwiftUI

struct PetView: View {
    // Shared customization data (from PetCustomization.swift)
    @EnvironmentObject var petCustomization: PetCustomization
    // Shared points/state for unlocking items (from StoreData.swift)
    @EnvironmentObject var storeData: StoreData
    
    // MARK: — View State
    /// Currently selected tab: "Colors", "Tops", or "Extras"
    @State private var selectedTab = "Colors"
    /// Which items the user has unlocked (persisted in UserDefaults)
    @State private var unlockedItems = Set(
        UserDefaults.standard.stringArray(forKey: "unlockedItems")
        ?? ["defaultcow"]
    )
    /// Controls display of "Not enough points" alert
    @State private var showAlert = false
    
    // MARK: – Navigation State  ← INSERTED
    @State private var showHomeNav      = false
    @State private var showResource     = false
    @State private var showSetGoal      = false
    @State private var showAnalyticsNav = false
    @State private var showSettingNav   = false
    
    // MARK: — UI Configuration
    /// Tab titles
    private let tabs = ["Colors", "Tops", "Extras"]
    
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color("lightd3cpurple")
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        // ─── Cow Display ─────────────────────────────────────────────
                        ZStack {
                            let width = geometry.size.width
                            let height = geometry.size.height
                            let posX = width / 1.57
                            let posY = height * 0.125
                            
                            // Shadow ellipse behind the cow
                            Ellipse()
                                .fill(Color("lightd3cpurple"))
                                .frame(width: 175, height: 75)
                                .shadow(color: .gray, radius: 10, x: 5, y: 5)
                                .position(x: posX * 0.8, y: posY * 2)
                            
                            // Layer 1: Outline - Always display the OUTLINE image first
                            petCustomization.colorcow
                                .resizable()
                                .scaledToFit()
                                .frame(width: width, height: height)
                                .position(x: posX, y: posY)
                            
                            // Layer 2: Color overlay - This should be the selected color
                            petCustomization.outlineImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: width, height: height)
                                .position(x: posX, y: posY)
                            
                            // Layer 3: Top accessory
                            petCustomization.topImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: width, height: height)
                                .position(x: posX, y: posY)
                            
                            // Layer 4: Extra accessory
                            petCustomization.extraImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: width, height: height)
                                .position(x: posX, y: posY)
                        }
                        
                        // ─── Tab Selector ──────────────────────────────────────────────
                        HStack(spacing: 12) {
                            ForEach(tabs, id: \.self) { tab in
                                Button(action: {
                                    selectedTab = tab
                                }) {
                                    Text(tab)
                                        .font(.custom("Jua", size: 15))
                                        .fontWeight(selectedTab == tab ? .bold : .regular)
                                        .foregroundColor(selectedTab == tab ? .white : .gray)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(
                                            selectedTab == tab
                                            ? Color.purple
                                            : Color.gray.opacity(0.2)
                                        )
                                        .cornerRadius(10)
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
                                    if unlockedItems.contains(name) {
                                        petCustomization.colorName = name
                                        petCustomization.saveCustomizations()
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
                                    if unlockedItems.contains(name) {
                                        petCustomization.topName = name
                                        petCustomization.saveCustomizations()
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
                                    if unlockedItems.contains(name) {
                                        petCustomization.extraName = name
                                        petCustomization.saveCustomizations()
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            }
            VStack {
                
                bottomTabBar
            }
            
            // Alert when user lacks points to unlock an item
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Not Enough Points"),
                    message: Text("You need more points to unlock this item."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                // Load saved customizations when view appears
                petCustomization.loadCustomizations()
            }
            // MARK: – Programmatic destinations  ← INSERTED
            .navigationDestination(isPresented: $showHomeNav)      { HomeView() }
            .navigationDestination(isPresented: $showResource)     { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal)      { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showSettingNav)   { SettingView() }
            .navigationBarBackButtonHidden(true)
        }
    }
    // ─── Grid Builder ────────────────────────────────────────────────────────
    /// Creates a 3-column grid of thumbnails with lock/unlock buttons.
    private func itemGrid(
        display: [String],
        items: [String],
        names: [String],
        geometry: GeometryProxy,
        action: @escaping (Int) -> Void
    ) -> some View {
        LazyVGrid(
            columns: Array(repeating: .init(.flexible(), spacing: 10), count: 3),
            spacing: 15
        ) {
            ForEach(items.indices, id: \.self) { index in
                VStack {
                    // Thumbnail image
                    Image(display[index])
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.width * 0.25,
                            height: geometry.size.width * 0.25
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            if unlockedItems.contains(items[index]) {
                                action(index)
                            }
                        }
                    
                    // Item name
                    Text(names[index])
                        .font(.caption)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    // Lock/Unlock button
                    Button {
                        if !unlockedItems.contains(items[index]) {
                            unlockItem(items[index])
                        }
                    } label: {
                        Text(unlockedItems.contains(items[index]) ? "Unlocked" : "Locked")
                            .font(.custom("Jua", size: 14))
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .background(
                                unlockedItems.contains(items[index])
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
    
    // ─── Unlock Logic & Persistence ────────────────────────────────────────
    /// Save the unlockedItems set to UserDefaults
    private func saveUnlockedItems() {
        UserDefaults.standard.set(
            Array(unlockedItems),
            forKey: "unlockedItems"
        )
    }
    
    /// Attempt to unlock an item by spending points
    private func unlockItem(_ item: String) {
        let cost = 50
        if storeData.totalPoints >= cost {
            // Deduct cost and add to unlocked set
            storeData.scores["spentUnlocks", default: 0] += cost
            unlockedItems.insert(item)
            saveUnlockedItems()
        } else {
            // Not enough points
            showAlert = true
        }
    }
    // ─── Bottom Tab Bar ─────────────────────────────────────────  ← INSERTED
    private var bottomTabBar: some View {
        HStack {
            Spacer()
            Button { withAnimation(.none) { showHomeNav = true } } label: {
                Image("Home Button")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showResource = true } } label: {
                Image("Resource Button")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showSetGoal = true } } label: {
                Image("Set Goal Button")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showAnalyticsNav = true } } label: {
                Image("Analytics Button")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button { withAnimation(.none) { showSettingNav = true } } label: {
                Image("Setting Button")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }
            Spacer()
        }
        .frame(height: 64)
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
