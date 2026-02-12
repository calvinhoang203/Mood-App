//
//  SettingView.swift
//  Mood-App
//
//  Created by Hieu Hoang on 4/22/25.
//

import SwiftUI
import FirebaseAuth
import UIKit

// MARK: - Editable Field Enum
enum EditableField {
    case name, pronouns, email, phone
}

struct SettingView: View {
    @EnvironmentObject private var storeData: StoreData
    @EnvironmentObject private var petCustomization: PetCustomization
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    
    // Navigation State
    @State private var showPetView = false
    @State private var notificationsEnabled: Bool = false
    @State private var showHomeNav = false
    @State private var showResource = false
    @State private var showSetGoal = false
    @State private var showAnalyticsNav = false
    @State private var showPet = false
    @State private var showSettingNav = false
    @State private var showLogoutAlert = false
    
    // Edit State
    @State private var editingField: EditableField?
    @State private var showEditAlert = false
    @State private var editInput1 = ""
    @State private var editInput2 = "" // Used for Last Name
    
    private let navBarHeight: CGFloat = 64
    
    // MARK: - Cow & Ellipsoid Layout Constants
    private let ellipsoidWidth: CGFloat = 250
    private let ellipsoidHeight: CGFloat = 70
    private let ellipsoidY: CGFloat = 150
    private let editIconSize: CGFloat = 36
    private let editIconOffsetX: CGFloat = 100
    private let editIconY: CGFloat = 170
    
    private let cowColorWidth: CGFloat = 800
    private let cowColorHeight: CGFloat = 800
    private let cowColorX: CGFloat = 285
    private let cowColorY: CGFloat = 30
    private let cowOutlineWidth: CGFloat = 800
    private let cowOutlineHeight: CGFloat = 800
    private let cowOutlineX: CGFloat = 285
    private let cowOutlineY: CGFloat = 30
    
    var body: some View {
        ZStack {
            Color("lightd3cpurple").ignoresSafeArea()
            NavigationStack {
                ZStack {
                    Color("lightd3cpurple").ignoresSafeArea()
                    
                    // MARK: - Main Vertical Stack
                    VStack(spacing: 0) {
                        
                        // 1. FIXED HEADER (Non-Scrollable)
                        VStack(spacing: 32) {
                            // --- Top Bar ---
                            HStack(alignment: .center) {
                                Text("Your Avatar")
                                    .font(.custom("Alexandria-Regular", size: 24).weight(.bold))
                                Spacer()
                                NavigationLink(destination: NotificationView().environmentObject(storeData)) {
                                    Image("Notification Icon")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .padding(.top, 24)
                            .padding(.horizontal, 24)
                            
                            // --- Avatar Section ---
                            GeometryReader { geometry in
                                ZStack {
                                    Ellipse()
                                        .fill(Color("d3cpurple"))
                                        .frame(width: ellipsoidWidth, height: ellipsoidHeight)
                                        .shadow(color: .gray, radius: 9, x: 5, y: 5)
                                        .position(x: geometry.size.width / 2, y: ellipsoidY)
                                    
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
                        }
                        // Add some spacing below the cow before the scroll starts
                        .padding(.bottom, 20)
                        
                        // 2. SCROLLABLE CONTENT (Forms & Buttons)
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 32) {
                                // --- Personal Info ---
                                InfoSection(title: "Personal Info") {
                                    VStack(alignment: .leading) {
                                        InfoRow(label: "NAME", value: "\(storeData.firstName) \(storeData.lastName)") {
                                            startEditing(.name)
                                        }
                                        Divider()
                                        InfoRow(label: "PRONOUNS", value: storeData.pronouns) {
                                            startEditing(.pronouns)
                                        }
                                    }
                                }
                                
                                // --- Contact Info ---
                                InfoSection(title: "Contact Info") {
                                    VStack(alignment: .leading) {
                                        InfoRow(label: "EMAIL", value: storeData.email) {
                                            startEditing(.email)
                                        }
                                        Divider()
                                        InfoRow(label: "PHONE", value: storeData.phoneNumber) {
                                            startEditing(.phone)
                                        }
                                    }
                                }
                                
                                // --- Custom Quote ---
                                InfoSection(title: "Homepage Quote") {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("CUSTOM QUOTE (MAX 77 CHARS)")
                                            .font(.custom("Alexandria-Regular", size: 12))
                                            .padding(.bottom, 2)
                                        
                                        TextField("Enter your quote here...", text: Binding(
                                            get: { storeData.customQuote },
                                            set: { newValue in
                                                if newValue.count <= 77 {
                                                    storeData.customQuote = newValue
                                                    storeData.saveToFirestore()
                                                }
                                            }
                                        ))
                                        .font(.custom("Alexandria-Regular", size: 15))
                                        .padding(.vertical, 4)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        
                                        HStack {
                                            Spacer()
                                            Text("\(storeData.customQuote.count)/77")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
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
                                
                                // Extra spacer at bottom so content isn't hidden behind tab bar
                                Spacer(minLength: 80)
                            }
                            .padding(.top, 10)
                        }
                    }
                    
                    // 3. Bottom Tab Bar
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
                // .navigationDestination(isPresented: $showSettingNav) { SettingView() } // Removed to prevent self-nav
                .navigationDestination(isPresented: $showPetView) {
                    PetView()
                        .environmentObject(storeData)
                        .environmentObject(petCustomization)
                }
                .navigationBarBackButtonHidden(true)
                // LOGOUT ALERT
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
                // EDIT INFO ALERT
                .alert("Edit Info", isPresented: $showEditAlert, actions: {
                    if editingField == .name {
                        TextField("First Name", text: $editInput1)
                        TextField("Last Name", text: $editInput2)
                    } else {
                        TextField("Value", text: $editInput1)
                    }
                    Button("Cancel", role: .cancel) { }
                    Button("Save") { saveEdits() }
                }, message: {
                    Text("Update your information below.")
                })
            }
            .padding(.top, 5)
        }
    }
    
    // MARK: - Logic Helpers
    private func startEditing(_ field: EditableField) {
        editingField = field
        switch field {
        case .name:
            editInput1 = storeData.firstName
            editInput2 = storeData.lastName
        case .pronouns:
            editInput1 = storeData.pronouns
        case .email:
            editInput1 = storeData.email
        case .phone:
            editInput1 = storeData.phoneNumber
        }
        showEditAlert = true
    }
    
    private func saveEdits() {
        guard let field = editingField else { return }
        switch field {
        case .name:
            storeData.firstName = editInput1
            storeData.lastName = editInput2
        case .pronouns:
            storeData.pronouns = editInput1
        case .email:
            storeData.email = editInput1
        case .phone:
            storeData.phoneNumber = editInput1
        }
        storeData.saveToFirestore()
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
            
            // MARK: - FIX: Disabled Action to prevent crash
            Button {
                // Do nothing since we are already on SettingView
            } label: {
                Image("Setting Button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
                    // Optional: Add a visual cue (like opacity) to show it's selected
                    .opacity(1.0)
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

// MARK: - Components
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

// Updated InfoRow to be clickable
struct InfoRow: View {
    let label: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(label)
                        .font(.custom("Alexandria-Regular", size: 12))
                        .foregroundColor(.black)
                        .padding(.bottom, 2)
                    Text(value)
                        .font(.custom("Alexandria-Regular", size: 15).weight(.bold))
                        .foregroundColor(.black)
                        .padding(.vertical, 4)
                }
                Spacer()
                // Visual cue that this row is editable
                Image(systemName: "pencil")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("d3cpurple"))
            }
        }
        .buttonStyle(.plain) // Prevents the whole list row highlight effect if not desired
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(StoreData())
            .environmentObject(PetCustomization())
    }
}
