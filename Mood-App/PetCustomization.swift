//
//  PetCustomization.swift
//  Mood-App
//
//  Created by Hieu Hoang on 4/22/25.
//

import SwiftUI

// MARK: – View‑Model

final class PetCustomization: ObservableObject {
    @Published var defaultcow : Image = Image("defaultcow")
    @Published var colorcow   : Image = Image("OUTLINE")
    @Published var topImage   : Image = Image("tophat")
    @Published var extraImage : Image = Image("earing")
}

// MARK: – PetView

struct PetView: View {
    @EnvironmentObject private var petCustomization: PetCustomization
    @EnvironmentObject private var storeData        : StoreData

    // Tabs
    enum Tab: String, CaseIterable {
        case colors = "COLORS"
        case tops   = "TOPS"
        case extras = "EXTRAS"
    }
    @State private var selectedTab: Tab = .colors

    // Persisted unlock state
    @State private var unlockedItems: Set<String> = {
        Set(UserDefaults.standard.stringArray(forKey: "unlockedItems") ?? ["defaultcow"])
    }()
    @State private var showAlert = false

    // Unlock cost
    private let unlockCost = 0

    // Assets for each tab
    private let colorDisplays = [
        "displayblue","displaydarkpurple","displaygreen",
        "displaylightgreen","displaypeach","displaypink",
        "displaypurple","displayred","displayyellow"
    ]
    private let colorAssets = [
        "bluecow","darkpurplecow","darkgreencow",
        "lightgreencow","peachcow","pinkcow",
        "purplecow","redcow","yellowcow"
    ]
    private let topAssets = ["tophat","hoodie","bowtie"]
    private let extraDisplays = [
        "earingview","glassesview","hatview",
        "necklaceview","videogameview","basketballview",
        "bowview","bobaview","pantsview",
        "maskview","airpodsview"
    ]
    private let extraAssets = [
        "earing","glasses","hat",
        "necklace","videogame","basketball",
        "bow","boba","pants",
        "mask","airpods"
    ]

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()

            GeometryReader { geo in
                VStack(spacing: 16) {
                    avatarSection(in: geo.size)
                    tabBar
                    grid(in: geo.size)
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .alert("Not enough points to unlock.", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: — Header
    private var header: some View {
        HStack {
            Text("Your Avatar")
                .font(.title2.bold())
            Spacer()
            Button { /* TODO: SavedPageView */ } label: {
                Image("Bookmark Icon").renderingMode(.original)
            }
            Button { /* TODO: NotificationView */ } label: {
                Image("Notification Icon").renderingMode(.original)
            }
        }
        .padding()
        .background(Color("lavenderColor"))
    }

    // MARK: — Avatar + Edit
    private func avatarSection(in size: CGSize) -> some View {
        ZStack {
            Ellipse()
                .fill(Color("lightd3cpurple"))
                .frame(width: size.width * 0.6,
                       height: size.height * 0.1)
                .offset(y: size.height * 0.05)

            petCustomization.defaultcow
                .resizable().scaledToFit()
            petCustomization.colorcow
                .resizable().scaledToFit()
            petCustomization.topImage
                .resizable().scaledToFit()
            petCustomization.extraImage
                .resizable().scaledToFit()

            NavigationLink(destination: PetView()) {
                Image("Edit Icon")
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .offset(x: size.width * 0.35, y: -size.height * 0.12)
        }
        .frame(height: size.height * 0.3)
    }

    // MARK: — Tab Bar
    private var tabBar: some View {
        HStack(spacing: 12) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button(tab.rawValue) {
                    selectedTab = tab
                }
                .font(.subheadline.bold())
                .foregroundColor(selectedTab == tab ? .white : .gray)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(selectedTab == tab
                            ? Color.purple
                            : Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
    }

    // MARK: — Grid
    private func grid(in size: CGSize) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                switch selectedTab {
                case .colors:
                    ForEach(colorAssets.indices, id: \.self) { idx in
                        tile(
                            display: colorDisplays[idx],
                            asset:  colorAssets[idx]
                        ) {
                            petCustomization.colorcow = Image(colorAssets[idx])
                        }
                    }
                case .tops:
                    ForEach(topAssets.indices, id: \.self) { idx in
                        tile(
                            display: topAssets[idx],
                            asset:  topAssets[idx]
                        ) {
                            petCustomization.topImage = Image(topAssets[idx])
                        }
                    }
                case .extras:
                    ForEach(extraAssets.indices, id: \.self) { idx in
                        tile(
                            display: extraDisplays[idx],
                            asset:  extraAssets[idx]
                        ) {
                            petCustomization.extraImage = Image(extraAssets[idx])
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }

    // MARK: — Single Tile
    @ViewBuilder
    private func tile(display: String, asset: String, action: @escaping ()->Void) -> some View {
        VStack(spacing: 8) {
            Image(display)
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)

            if unlockedItems.contains(asset) {
                Button("EQUIP") { action() }
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(6)

            } else {
                Button("LOCKED") { attemptUnlock(asset: asset) }
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(6)
            }
        }
    }

    // MARK: — Unlock Logic
    private func attemptUnlock(asset: String) {
        guard storeData.scores.values.reduce(0,+) >= unlockCost else {
            showAlert = true
            return
        }
        storeData.scores["POINTS", default: 0] -= unlockCost
        unlockedItems.insert(asset)
        UserDefaults.standard.set(Array(unlockedItems), forKey: "unlockedItems")
    }
}

// MARK: – Preview

struct PetView_Previews: PreviewProvider {
    static var previews: some View {
        PetView()
            .environmentObject(PetCustomization())
            .environmentObject(StoreData())
    }
}
