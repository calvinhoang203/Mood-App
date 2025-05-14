import SwiftUI

// MARK: - Tab Enum

enum MainTab: Int, CaseIterable, Identifiable {
    case home, resources, setGoal, analytics, pet, settings
    
    var id: Int { rawValue }
    
    var iconName: String {
        switch self {
        case .home: return "Home Button"
        case .resources: return "Resource Button"
        case .setGoal: return "Set Goal Button"
        case .analytics: return "Analytics Button"
        case .pet: return "Pet Button"
        case .settings: return "Setting Button"
        }
    }
    
    var view: AnyView {
        switch self {
        case .home: return AnyView(HomeView())
        case .resources: return AnyView(ResourcesView())
        case .setGoal: return AnyView(SetGoalView())
        case .analytics: return AnyView(AnalyticsPageView())
        case .pet: return AnyView(PetView())
        case .settings: return AnyView(SettingView())
        }
    }
}

// MARK: - SelectedTab EnvironmentKey
private struct SelectedTabKey: EnvironmentKey {
    static let defaultValue: Binding<MainTab>? = nil
}

extension EnvironmentValues {
    var selectedTab: Binding<MainTab>? {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
    }
}

// MARK: - TabNavigator

struct TabNavigator<Content: View>: View {
    @Binding var selectedTab: MainTab
    @Namespace private var animation
    @State private var previousTab: MainTab = .home
    @ViewBuilder let content: (MainTab) -> Content
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content(selectedTab)
                    .transition(transition(for: selectedTab, previous: previousTab))
                    .id(selectedTab)
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.2), value: selectedTab)
            
            Divider()
            bottomTabBar
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            previousTab = oldValue
        }
        .environment(\.selectedTab, $selectedTab)
    }
    
    private var bottomTabBar: some View {
        HStack {
            ForEach(MainTab.allCases) { tab in
                Spacer()
                Button(action: {
                    if selectedTab != tab {
                        selectedTab = tab
                    }
                }) {
                    Image(tab.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .opacity(selectedTab == tab ? 1.0 : 0.7)
                        .scaleEffect(selectedTab == tab ? 1.15 : 1.0)
                        .animation(.spring(), value: selectedTab == tab)
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
        .frame(height: 64)
        .background(Color.white)
    }
    
    private func transition(for newTab: MainTab, previous: MainTab) -> AnyTransition {
        let allTabs = MainTab.allCases
        guard let newIndex = allTabs.firstIndex(of: newTab),
              let prevIndex = allTabs.firstIndex(of: previous) else {
            return .identity
        }
        if newIndex == prevIndex { return .identity }
        let direction: Edge = newIndex > prevIndex ? .trailing : .leading
        return .asymmetric(
            insertion: .move(edge: direction),
            removal: .move(edge: direction == .trailing ? .leading : .trailing)
        )
    }
}

// MARK: - Preview

#Preview {
    struct DemoRoot: View {
        @State private var selectedTab: MainTab = .home
        var body: some View {
            TabNavigator(selectedTab: $selectedTab) { tab in
                tab.view
            }
            .environmentObject(StoreData())
            .environmentObject(PetCustomization())
        }
    }
    return DemoRoot()
} 