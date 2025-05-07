import SwiftUI

class SavedItems: ObservableObject {
    
    /* @Published --> property wrapper: Notifying other views of Update and views being updated with the change
     didset --> property observer: when activity added or removed, didset calls saveToUserDefaults */
    
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


    /*These two functions use UserDefaults to save and load data
      Saves Data even when iPhone turns off or restarts
      Codable - encoding Data and Encoding
      JSONEncoder = Swift objects to JSON data
      JSONDecoder = JSON data back to Swift Objects */
    
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


    /*let index = [code] tells swiftui to find the first instance of activity being indexed and then remove it at that index
                   if activity exists, remove, if it doesn't, add */
    
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
    //Straightforward, if activity saved, return True
    func isActivitySaved(_ activity: Activity) -> Bool {
        savedActivities.contains(activity)
    }

    func isResourceSaved(_ resource: Resource) -> Bool {
        savedResources.contains(resource)
    }

    // MARK: - Toggle Planner Adds

    func toggleAddedActivity(_ activity: Activity) {
        if let index = addedActivities.firstIndex(of: activity) {
            addedActivities.remove(at: index)
        } else {
            addedActivities.append(activity)
        }
    }
    /*Same logic for the third row in ResourcePersonalView...checking if the activity is ADDED now and not just saved
      Used for when switching between filled heart for saved or blank heart if not,
      purple to green when activity added... etc */
    
    func isActivityAdded(_ activity: Activity) -> Bool {
        addedActivities.contains(activity)
    }

    func toggleAddedResource(_ resource: Resource) {
        if let index = addedResources.firstIndex(of: resource) {
            addedResources.remove(at: index)
        } else {
            addedResources.append(resource)
        }
    }

    func isResourceAdded(_ resource: Resource) -> Bool {
        addedResources.contains(resource)
    }
}
