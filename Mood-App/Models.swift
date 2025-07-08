
/* Identifiable allows Activity and Resource objects to be iterated through ForEach loops
   Codable: Encoding and Decoding of Swift Objects <--> JSON
            JSON file format allows Swift to save data into a storable format
   Hashbale: Unique hash values for each Activity and Resource Object
             Allows Swift to use the .contains() and .firstIndexOf() functions */
import Foundation
import SwiftUI

struct Activity: Identifiable, Codable, Hashable {
    var id: String { name } // deterministic id
    let name: String
    let imageName: String
    let description: String
    let tags: [String] // ✅ new parameter

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
    let tags: [String] // ✅ new parameter

    static func == (lhs: Resource, rhs: Resource) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
