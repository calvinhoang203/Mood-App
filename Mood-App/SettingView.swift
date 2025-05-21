//
//  SettingView.swift
//  Mood-App
//
//  Created by Hieu Hoang on 4/22/25.
//


//your avataar ui, notifications, banner add
//add navbar, add shadow below white, add scrollable
//add designer's toggle ui
//need to see firebase schema to connect it to firebase variables
import SwiftUI
import FirebaseAuth
import UIKit

struct SettingView: View {
    @EnvironmentObject private var storeData: StoreData
    @EnvironmentObject private var petCustomization: PetCustomization
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @State private var showPetView = false
    @State private var notificationsEnabled: Bool = false
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false
    @State private var showLogoutAlert = false
    private let navBarHeight: CGFloat = 64
    
    // MARK: - Cow & Ellipsoid Layout Constants (Adjust here)
    private let ellipsoidWidth: CGFloat = 250
    private let ellipsoidHeight: CGFloat = 70
    private let ellipsoidY: CGFloat = 150
    private let editIconSize: CGFloat = 36
    private let editIconOffsetX: CGFloat = 100 // relative to center
    private let editIconY: CGFloat = 170
    // ---
    // Cow Layer Layouts (match PetView)
    private let cowColorWidth: CGFloat = 800
    private let cowColorHeight: CGFloat = 800
    private let cowColorX: CGFloat = 285
    private let cowColorY: CGFloat = 30
    private let cowOutlineWidth: CGFloat = 800
    private let cowOutlineHeight: CGFloat = 800
    private let cowOutlineX: CGFloat = 285
    private let cowOutlineY: CGFloat = 30
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("lightd3cpurple").ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // --- Top Bar: Title + Icon Buttons (Bookmark & Notification) ---
                        HStack(alignment: .center) {
                            Text("Your Avatar")
                                .font(.custom("Alexandria-Regular", size: 24).weight(.bold))
                            Spacer()
                            NavigationLink(destination: SavedPageView()) {
                                Image("Bookmark Icon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            NavigationLink(destination: NotificationView()) {
                                Image("Notification Icon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                        // --- Avatar Section (Cow, Ellipsoid, Edit) ---
                        GeometryReader { geometry in
                            ZStack {
                                // Ellipsoid shadow (adjustable)
                                Ellipse()
                                    .fill(Color("d3cpurple"))
                                    .frame(width: ellipsoidWidth, height: ellipsoidHeight)
                                    .shadow(color: .gray, radius: 9, x: 5, y: 5)
                                    .position(x: geometry.size.width / 2, y: ellipsoidY)
                                // Cow color layer
                                petCustomization.colorcow
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cowColorWidth, height: cowColorHeight)
                                    .position(x: cowColorX, y: cowColorY)
                                // Cow outline layer
                                petCustomization.outlineImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: cowOutlineWidth, height: cowOutlineHeight)
                                    .position(x: cowOutlineX, y: cowOutlineY)
                                // Top accessory (if any)
                                if !petCustomization.topName.isEmpty {
                                    petCustomization.topImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: cowColorWidth, height: cowColorHeight)
                                        .position(x: cowColorX, y: cowColorY)
                                }
                                // Extra accessory (if any)
                                if !petCustomization.extraName.isEmpty {
                                    petCustomization.extraImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: cowColorWidth, height: cowColorHeight)
                                        .position(x: cowColorX, y: cowColorY)
                                }
                                // Edit icon (adjustable)
                                Button {
                                    showPetView = true
                                } label: {
                                    Image("Edit Icon")
                                        .resizable()
                                        .frame(width: editIconSize, height: editIconSize)
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                .position(x: geometry.size.width / 2 + editIconOffsetX, y: editIconY)
                            }
                            .frame(height: max(ellipsoidY + ellipsoidHeight/2, cowColorY + cowColorHeight/2, editIconY + editIconSize/2))
                        }
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        // --- Personal Info ---
                        InfoSection(title: "Personal Info") {
                            VStack(alignment: .leading) {
                                InfoRow(label: "NAME", value: "\(storeData.firstName) \(storeData.lastName)", action: {})
                                InfoRow(label: "PRONOUNS", value: storeData.pronouns, action: {})
                            }
                        }
                        // --- Contact Info ---
                        InfoSection(title: "Contact Info") {
                            VStack(alignment: .leading) {
                                InfoRow(label: "EMAIL", value: storeData.email, action: {})
                                InfoRow(label: "PHONE", value: storeData.phoneNumber, action: {})
                            }
                        }
                        // --- Preference Info ---
                        InfoSection(title: "Preference Info") {
                            HStack {
                                Text("NOTIFICATIONS")
                                    .font(.custom("Alexandria-Regular", size: 15))
                                    .foregroundColor(.black)
                                Spacer()
                                Toggle(isOn: $notificationsEnabled) {
                                    EmptyView()
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color("d3cpurple")))
                                .labelsHidden()
                                Text(notificationsEnabled ? "ON" : "OFF")
                                    .font(.custom("Alexandria-Regular", size: 15))
                                    .foregroundColor(.black)
                            }
                        }
                        // --- Log Out Button ---
                        VStack(spacing: 16) {
                            Text("Ready to sign off?")
                                .font(.custom("Alexandria-Regular", size: 17).weight(.semibold))
                            Button(action: { showLogoutAlert = true }) {
                                Image("Log Out Button")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 48)
                            }
                        }
                        .padding(.top, 8)
                        Spacer(minLength: 32)
                    }
                    .padding(.bottom, 32)
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
            .navigationDestination(isPresented: $showPetView) {
                PetView()
                    .environmentObject(storeData)
                    .environmentObject(petCustomization)
            }
            .navigationBarBackButtonHidden(true)
            .alert("Are you sure you want to log out?", isPresented: $showLogoutAlert) {
                Button("Yes", role: .destructive) {
                    do {
                        try Auth.auth().signOut()
                        storeData.reset()
                        isLoggedIn = false
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }
                Button("No", role: .cancel) {}
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

struct InfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("Alexandria-Regular", size: 17).weight(.bold))
            content
                .padding()
                .background(Color.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(label)
                    .font(.custom("Alexandria-Regular", size: 12))
                    .padding(.bottom, 2)
                Text(value)
                    .font(.custom("Alexandria-Regular", size: 15).weight(.bold))
                    .padding(.vertical, 4)
            }
            Spacer()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(StoreData())
            .environmentObject(PetCustomization())
    }
}
