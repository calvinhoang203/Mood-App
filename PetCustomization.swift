import SwiftUI

class PetCustomization: ObservableObject {
    @Published var defaultcow = Image("defaultcow")
    @Published var colorcow = Image("OUTLINE")
    @Published var topImage = Image("")
    @Published var extraImage = Image("")
}
