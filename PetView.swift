import SwiftUI

struct PetView: View {
    @EnvironmentObject var petCustomization: PetCustomization
    @EnvironmentObject var sharedData: SharedData
    @State private var selectedTab: String = "Colors"
    @State private var unlockedItems: Set<String> = Set(UserDefaults.standard.stringArray(forKey: "unlockedItems") ?? ["defaultcow"])
    @State private var showAlert: Bool = false

    let tabs = ["Colors", "Tops", "Extras"]

    let colorOptions: [String] = ["displayblue", "displaydarkpurple", "displaygreen", "displaylightgreen", "displaypeach", "displaypink", "displaypurple", "displayred", "displayyellow"]
    let colorImages: [String] = ["bluecow", "darkpurplecow", "darkgreencow", "lightgreencow", "peachcow", "pinkcow", "purplecow", "redcow", "yellowcow"]
    let colorNames: [String] = ["Red", "Blue", "Dark Green", "Green", "Peach", "Purple", "Pink", "Dark Peach", "Default"]

    let topImages: [String] = ["tophat", "hoodie", "bowtie"]
    let topNames: [String] = ["Top Hat", "Hoodie", "Bow Tie"]

    let extraImages: [String] = ["earing", "glasses", "hat", "necklace", "videogame", "basketball", "bow", "boba", "pants", "mask", "airpods"]
    let extraNames: [String] = ["Earing", "Glasses", "Hat", "Necklace", "Video Game", "Basketball", "Bow", "Boba", "Pants", "Mask", "AirPods"]
    let extraDisplayImages = ["earingview", "glassesview", "hatview", "necklaceview", "videogameview", "basketballview", "bowview", "bobaview", "pantsview", "maskview", "airpodsview"]

    var body: some View {
        ZStack {
            Color("lightd3cpurple").ignoresSafeArea()

            GeometryReader { geometry in
                VStack(spacing: 12) {
                    HStack {
                        Text("Your Avatar")
                            .font(.custom("Alexandria-Regular", size: 18))
                            .font(.headline)
                            .padding(.leading, 30)
                            .padding(.top, 15)
                        Spacer()
                    }

                    ZStack {
                        let imageWidth = geometry.size.width * 1.25
                        let imageHeight = geometry.size.height * 1.25
                        let position_x = geometry.size.width / 1.5
                        let position_y = geometry.size.height * 0.25

                        Ellipse()
                            .fill(Color("elipsecolor"))
                            .frame(width: 200, height: 50)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 9, x: 5, y: 5)
                            .position(x: position_x * 0.75, y: position_y * 0.75)

                        petCustomization.defaultcow
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .position(x: position_x, y: position_y * 0.20)

                        petCustomization.colorcow
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .position(x: position_x, y: position_y * 0.20)

                        petCustomization.topImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .position(x: position_x, y: position_y * 0.20)

                        petCustomization.extraImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .position(x: position_x, y: position_y * 0.20)
                    }

                    VStack {
                        HStack {
                            ForEach(tabs, id: \.self) { tab in
                                Button(action: { selectedTab = tab }) {
                                    Text(tab)
                                        .fontWeight(selectedTab == tab ? .bold : .regular)
                                        .foregroundColor(selectedTab == tab ? .white : .gray)
                                        .padding()
                                        .background(selectedTab == tab ? Color("elipsecolor") : Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .font(.custom("Alexandria-Regular", size: 15))
                                }
                            }
                        }

                        ScrollView {
                            if selectedTab == "Colors" {
                                itemGrid(display: colorOptions, items: colorImages, names: colorNames, geometry: geometry) { index in
                                    petCustomization.defaultCowName = colorImages[index]
                                }
                            } else if selectedTab == "Tops" {
                                itemGrid(display: topImages, items: topImages, names: topNames, geometry: geometry) { index in
                                    petCustomization.topImageName = topImages[index]
                                }
                            } else if selectedTab == "Extras" {
                                itemGrid(display: extraDisplayImages, items: extraImages, names: extraNames, geometry: geometry) { index in
                                    petCustomization.extraImageName = extraImages[index]
                                }
                            }
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, -150)
                }
            }

            VStack {
                homebar()
                    .frame(maxWidth: .infinity)
                    .background(Color("lightd3cpurple"))
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Not Enough Points"), message: Text("You need more points to unlock this item."), dismissButton: .default(Text("OK")))
        }
    }

    private func itemGrid(display: [String], items: [String], names: [String], geometry: GeometryProxy, action: @escaping (Int) -> Void) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 15) {
            ForEach(items.indices, id: \.self) { index in
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
                                if unlockedItems.contains(items[index]) {
                                    action(index)
                                }
                            }
                            .padding(.top, 15)
                    }

                    Button(unlockedItems.contains(items[index]) ? "UNLOCKED" : "LOCKED") {
                        unlockItem(items[index])
                    }
                    .font(.custom("Alexandria-Regular", size: 14))
                    .padding(5)
                    .background(unlockedItems.contains(items[index]) ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
            }
        }
    }

    private func unlockItem(_ item: String) {
        if !unlockedItems.contains(item) {
            if sharedData.points >= 50 {
                sharedData.points -= 50
                unlockedItems.insert(item)
                saveUnlockedItems()
            } else {
                showAlert = true
            }
        }
    }

    private func saveUnlockedItems() {
        UserDefaults.standard.set(Array(unlockedItems), forKey: "unlockedItems")
    }
}

struct PetView_Previews: PreviewProvider {
    static var previews: some View {
        PetView()
            .environmentObject(PetCustomization())
            .environmentObject(SharedData())
    }
}
