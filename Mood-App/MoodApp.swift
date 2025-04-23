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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var petCustomization = PetCustomization()

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
                .environmentObject(petCustomization)
            }
        }
    }
}
