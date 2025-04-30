import SwiftUI

class SavedItems: ObservableObject {
    @Published var savedActivities: [Activity] {
        didSet { saveToUserDefaults(savedActivities, key: "savedActivities") }
    }

    @Published var savedResources: [Resource] {
        didSet { saveToUserDefaults(savedResources, key: "savedResources") }
    }

    @Published var addedActivities: [Activity] {
        didSet { saveToUserDefaults(addedActivities, key: "addedActivities") }
    }

    @Published var addedResources: [Resource] {
        didSet { saveToUserDefaults(addedResources, key: "addedResources") }
    }

    init() {
        self.savedActivities = Self.loadFromUserDefaults(key: "savedActivities") ?? []
        self.savedResources = Self.loadFromUserDefaults(key: "savedResources") ?? []
        self.addedActivities = Self.loadFromUserDefaults(key: "addedActivities") ?? []
        self.addedResources = Self.loadFromUserDefaults(key: "addedResources") ?? []
    }

    // MARK: - Save / Load

    private func saveToUserDefaults<T: Codable>(_ value: T, key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private static func loadFromUserDefaults<T: Codable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return decoded
    }

    // MARK: - Toggle Favorites

    func toggleActivity(_ activity: Activity) {
        if let index = savedActivities.firstIndex(of: activity) {
            savedActivities.remove(at: index)
        } else {
            savedActivities.append(activity)
        }
    }

    func toggleResource(_ resource: Resource) {
        if let index = savedResources.firstIndex(of: resource) {
            savedResources.remove(at: index)
        } else {
            savedResources.append(resource)
        }
    }

    func isActivitySaved(_ activity: Activity) -> Bool {
        savedActivities.contains(activity)
    }

    func isResourceSaved(_ resource: Resource) -> Bool {
        savedResources.contains(resource)
    }

    // MARK: - Add to Planner

    func addActivityToPlanner(_ activity: Activity) {
        if !addedActivities.contains(activity) {
            addedActivities.append(activity)
        }
    }

    func isActivityAdded(_ activity: Activity) -> Bool {
        addedActivities.contains(activity)
    }

    func addResourceToPlanner(_ resource: Resource) {
        if !addedResources.contains(resource) {
            addedResources.append(resource)
        }
    }

    func isResourceAdded(_ resource: Resource) -> Bool {
        addedResources.contains(resource)
    }
}
