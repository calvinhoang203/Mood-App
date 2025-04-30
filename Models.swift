import Foundation

struct Activity: Identifiable, Codable, Hashable {
    var id: String { name } // makes id deterministic
    let name: String
    let imageName: String
    let description: String

    static func == (lhs: Activity, rhs: Activity) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct Resource: Identifiable, Codable, Hashable {
    var id: String { name }
    let name: String
    let imageName: String
    let description: String

    static func == (lhs: Resource, rhs: Resource) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

