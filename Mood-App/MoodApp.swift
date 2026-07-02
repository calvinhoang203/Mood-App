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
            Group {
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
            // The app's custom color assets were only ever designed for Light Mode —
            // every color's Dark Mode variant in Assets.xcassets is either missing or
            // incorrectly set to solid white, which makes text/backgrounds disappear
            // when a device is in Dark Mode. Force Light Mode until a real dark theme
            // is designed, rather than showing a broken, half-finished one.
            .preferredColorScheme(.light)
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
