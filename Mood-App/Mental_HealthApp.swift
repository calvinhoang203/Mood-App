//
//  Mental_HealthApp.swift
//  Mental Health
//
//
//

import SwiftUI
import Firebase

@main
struct Mental_HealthApp: App {
    @State private var showSplash = true
    @StateObject var storeData = StoreData()
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
            }
        }
    }
}
