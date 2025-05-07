//
//  MoodApp.swift
//  MoodApp
//
//
//

import SwiftUI
import Firebase

@main
struct MoodApp: App {
    @State private var showSplash = true
    @StateObject var storeData = StoreData()
    @StateObject private var petCustomization = PetCustomization()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplash = false
                        }
                    }
            } else {
                NavigationStack {
                    LoginView()
                }
                .environmentObject(storeData)
                .environmentObject(petCustomization)
            }
        }
    }
}
