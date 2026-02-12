import SwiftUI
import Firebase

@main
struct MoodApp: App {
    @State private var showSplash = true
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    @StateObject var storeData = StoreData()
    @StateObject private var petCustomization = PetCustomization()
    @StateObject private var savedItems = SavedItems()

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
            } else if !isLoggedIn {
                LoginRoot(
                    savedItems: savedItems,
                    storeData: storeData,
                    petCustomization: petCustomization
                )
            } else {
                HomeView()
                    .environmentObject(storeData)
                    .environmentObject(petCustomization)
                    .environmentObject(savedItems)
            }
        }
    }
}

private struct LoginRoot: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    let savedItems: SavedItems
    let storeData: StoreData
    let petCustomization: PetCustomization

    var body: some View {
        LoginView(isLoggedInBinding: $isLoggedIn)
            .environmentObject(storeData)
            .environmentObject(petCustomization)
            .environmentObject(savedItems)
    }
}
