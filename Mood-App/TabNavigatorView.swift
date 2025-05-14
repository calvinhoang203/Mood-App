import SwiftUI

struct TabNavigatorView: View {
    @State private var selectedTab: MainTab = .home
    @StateObject var storeData = StoreData()
    @StateObject private var petCustomization = PetCustomization()

    var body: some View {
        TabNavigator(selectedTab: $selectedTab) { tab in
            tab.view
                .environmentObject(storeData)
                .environmentObject(petCustomization)
        }
        .environmentObject(storeData)
        .environmentObject(petCustomization)
    }
}

struct TabNavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigatorView()
    }
} 