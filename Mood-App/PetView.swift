import SwiftUI

struct PetView: View {
    @EnvironmentObject var petCustomization: PetCustomization
    @EnvironmentObject var storeData: StoreData

    @State private var selectedTab = "Colors"
    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false

    private let tabs = ["Colors", "Tops", "Extras", "Pants"]
    private let colorCost = 20
    private let topCost = 20
    private let extraCost = 20

    private let colorOptions = ["" /* none */] + ["displayblue", "displaydarkpurple", "displaygreen", "displaylightgreen", "displaypeach", "displaypink", "displaypurple", "displayred"]
    private let colorImages = ["" /* none */] + ["bluecow", "darkpurplecow", "darkgreencow", "lightgreencow", "peachcow", "pinkcow", "purplecow", "redcow"]
    private let colorNames = ["None"] + ["Blue", "Dark Purple", "Dark Green", "Light Green", "Peach", "Pink", "Purple", "Red"]

    private let topImages = ["" /* none */] + ["suit", "iloved3c", "ilovemood",  "greenshirt", "pinkshirt", "peachshirt", "redshirt", "cyanshirt"]
    private let topNames = ["None"] + ["Suit", "D3C Shirt", "Moo'd Shirt",  "Green Shirt", "Pink Shirt", "Peach Shirt", "Red Shirt", "Cyan Shirt"]
    private let topDisplayImages = ["" /* none */] + [
            "suitview", "iloved3cview", "ilovemoodview", "greenshirtview",
            "pinkshirtview", "peachshirtview", "redshirtview", "cyanshirtview"
        ]

    private let extraDisplayImages = ["" /* none */] + ["earingview", "glassesview", "hatview", "necklaceview", "videogameview", "basketballview", "bowview", "bobaview", "maskview", "airpodsview"]
    private let extraImages = ["" /* none */] + ["earing", "glasses", "hat", "necklace", "videogame", "basketball", "bow", "boba", "mask", "airpods"]
    private let extraNames = ["None"] + ["Earring", "Glasses", "Hat", "Necklace", "Video Game", "Basketball", "Bow", "Boba", "Mask", "AirPods"]

    private let pantsDisplayImages = ["" /* none */] + ["pantsview", "brownpantsview", "bluepantsview", "blackpantsview"]
    private let pantsImages = ["" /* none */] + ["pants", "brownpants", "bluepants", "blackpants"]
    private let pantsNames = ["None"] + ["Pants", "Brown Pants", "Blue Pants", "Black Pants"]


    @State private var cowColorWidth: CGFloat = 800
    @State private var cowColorHeight: CGFloat = 800
    @State private var cowColorX: CGFloat = 289
    @State private var cowColorY: CGFloat = 0
    @State private var cowOutlineWidth: CGFloat = 800
    @State private var cowOutlineHeight: CGFloat = 800
    @State private var cowOutlineX: CGFloat = 289
    @State private var cowOutlineY: CGFloat = 0
    @State private var navBarHeight: CGFloat = 64
    
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

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lightd3cpurple")
                    .ignoresSafeArea()

                GeometryReader { geometry in
                    VStack(spacing: 12) {
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
                                .padding(.leading, 30)
                                .padding(.top, 15)
                            Spacer()
                        }

                        ZStack {
                            let posX = geometry.size.width / 1.57
                            let posY = geometry.size.height * 0.125

                            Ellipse()
                                .fill(Color("d3cpurple"))
                                .frame(width: 250, height: 70)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 9, x: 5, y: 5)
                                .position(x: posX * 0.8, y: posY * 1.2)

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
                            
                                petCustomization.pantsImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cowColorWidth, height: cowColorHeight)
                                    .position(x: cowColorX, y: cowColorY)
                            

                                petCustomization.topImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cowColorWidth, height: cowColorHeight)
                                    .position(x: cowColorX, y: cowColorY)
                            

                                petCustomization.extraImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cowColorWidth, height: cowColorHeight)
                                    .position(x: cowColorX, y: cowColorY)
                            
                        }


                        HStack(spacing: 12) {
                            ForEach(tabs, id: \.self) { tab in
                                Button(action: { selectedTab = tab }) {
                                    Text(tab)
                                        .fontWeight(selectedTab == tab ? .bold : .regular)
                                        .foregroundColor(selectedTab == tab ? .white : .gray)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(selectedTab == tab ? Color("d3cpurple") : Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .font(.custom("Alexandria-Regular", size: 15))
                                }
                            }
                        }
                        .padding(.vertical, 2)

                        ScrollView {
                            if selectedTab == "Colors" {
                                itemGrid(display: colorOptions, items: colorImages, names: colorNames, geometry: geometry) { index in
                                    let name = colorImages[index]
                                    if petCustomization.unlockedItems.contains(name) {
                                        petCustomization.updateColor(name)
                                    }
                                }
                            } else if selectedTab == "Tops" {
                                itemGrid(display: topDisplayImages, items: topImages, names: topNames, geometry: geometry) { index in
                                    let name = topImages[index]
                                    if petCustomization.unlockedItems.contains(name) {
                                        petCustomization.updateTop(name)
                                    }
                                }
                            } else if selectedTab == "Extras" {
                                itemGrid(display: extraDisplayImages, items: extraImages, names: extraNames, geometry: geometry) { index in
                                    let name = extraImages[index]
                                    if petCustomization.unlockedItems.contains(name) {
                                        petCustomization.updateExtra(name)
                                    }
                                }
                            } else if selectedTab == "Pants" {
                                itemGrid(display: pantsDisplayImages, items: pantsImages, names: pantsNames, geometry: geometry) { index in
                                    let name = pantsImages[index]
                                    if petCustomization.unlockedItems.contains(name) {
                                        petCustomization.updatePants(name)
                                    }
                                }
                            }
                        }
                        .frame(height: geometry.size.height * 0.4)
                        .frame(width: geometry.size.width * 0.9)

                        .layoutPriority(1)

                        Spacer()
                    }
                    .padding(.bottom, navBarHeight + 10)
                }

                VStack(spacing: 0) {
                    Spacer()
                    bottomTabBar
                }
            }
            .onAppear {
                petCustomization.fetchInitialCustomizations()
            }
            .onChange(of: showAlert) {
                petCustomization.fetchInitialCustomizations()
            }
            .navigationDestination(isPresented: $showHomeNav) { HomeView() }
            .navigationDestination(isPresented: $showResource) { ResourcesView() }
            .navigationDestination(isPresented: $showSetGoal) { SetGoalView() }
            .navigationDestination(isPresented: $showAnalyticsNav) { AnalyticsPageView() }
            .navigationDestination(isPresented: $showSettingNav) { SettingView() }
            .navigationBarBackButtonHidden(true)
            .onDisappear {
                petCustomization.fetchInitialCustomizations()
                petCustomization.saveUserCustomizations()
            }
        }
    }

    private func itemGrid(display: [String], items: [String], names: [String], geometry: GeometryProxy, action: @escaping (Int) -> Void) -> some View {
        let cost: (Int) -> Int = { index in
            let name = items[index]
            if name.isEmpty {
                return 0 // "None" option is always free
            } else if items == colorImages {
                return colorCost
            } else if items == topImages {
                return topCost
            } else if items == extraImages || items == pantsImages {
                return extraCost
            } else {
                return 50
            }
        }
        return LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 3), spacing: 15) {
            ForEach(0..<items.count, id: \.self) { index in
                VStack(spacing: 6) {
                    ZStack {
                        Ellipse()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: geometry.size.width * 0.20, height: geometry.size.width * 0.05)
                            .offset(y: geometry.size.width * 0.065)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                        Image(display[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                if petCustomization.unlockedItems.contains(items[index]) {
                                    action(index)
                                    if items == colorImages {
                                        petCustomization.saveUserCustomizations()
                                    }
                                }
                            }
                            .padding(.top, 15)
                    }
                    Text(names[index])
                        .font(.custom("Alexandria-Regular", size: 13))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text("\(cost(index)) pts")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Button {
                        if !petCustomization.unlockedItems.contains(items[index]) {
                            petCustomization.unlockItem(items[index], storeData: storeData) { success in
                                if !success {
                                    alertMessage = "You need \(cost(index)) points to unlock this item."
                                    showAlert = true
                                }
                            }
                        }
                    } label: {
                        Text(petCustomization.unlockedItems.contains(items[index]) ? "Unlocked" : "Locked")
                            .font(.custom("Alexandria-Regular", size: 14))
                            .padding(5)
                            .frame(width: 100)
                            .background(petCustomization.unlockedItems.contains(items[index]) ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            }
        }
    }

   
}

struct PetView_Previews: PreviewProvider {
    static var previews: some View {
        PetView()
            .environmentObject(StoreData())
            .environmentObject(PetCustomization())
    }
}
