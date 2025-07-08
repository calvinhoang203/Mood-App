import SwiftUI

class SavedItems: ObservableObject {
    @Published private(set) var savedActivities: [Activity]
    @Published private(set) var savedResources: [Resource]
    @Published private(set) var addedActivities: [Activity]
    @Published private(set) var addedResources: [Resource]

    init() {
        self.savedActivities = Self.loadFromUserDefaults(key: "savedActivities") ?? []
        self.savedResources = Self.loadFromUserDefaults(key: "savedResources") ?? []
        self.addedActivities = Self.loadFromUserDefaults(key: "addedActivities") ?? []
        self.addedResources = Self.loadFromUserDefaults(key: "addedResources") ?? []
    }

    // MARK: - Toggle & Add Methods

    func toggleActivity(_ activity: Activity) {
        if let index = savedActivities.firstIndex(of: activity) {
            savedActivities.remove(at: index)
        } else {
            savedActivities.append(activity)
        }
        saveToUserDefaults(savedActivities, key: "savedActivities")
    }

    func toggleResource(_ resource: Resource) {
        if let index = savedResources.firstIndex(of: resource) {
            savedResources.remove(at: index)
        } else {
            savedResources.append(resource)
        }
        saveToUserDefaults(savedResources, key: "savedResources")
    }

    func addActivity(_ activity: Activity) {
        if !addedActivities.contains(activity) {
            addedActivities.append(activity)
            saveToUserDefaults(addedActivities, key: "addedActivities")
        }
    }

    func addResource(_ resource: Resource) {
        if !addedResources.contains(resource) {
            addedResources.append(resource)
            saveToUserDefaults(addedResources, key: "addedResources")
        }
    }

    // MARK: - Check Methods

    func isActivitySaved(_ activity: Activity) -> Bool {
        savedActivities.contains(activity)
    }

    func isResourceSaved(_ resource: Resource) -> Bool {
        savedResources.contains(resource)
    }

    // MARK: - Persistence Helpers

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
}
