import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class PetCustomization: ObservableObject {
    // 1) The outline cow – always drawn on top of your color layer
    private let outlineImageName = "OUTLINE"
    var outlineImage: Image { Image(outlineImageName) }
    
    // 1b) The default **fill** color for your cow
    private let defaultColorName = "defaultcow"
    
    // 2) persisted choices
    @Published var colorName: String = ""    // the “current” color layer
    @Published var topName: String = ""
    @Published var extraName: String = ""
    
    // 3) composed views
    /// Color layer – if no colorName chosen yet, show your defaultcow asset
    var colorcow: Image {
        let name = colorName.isEmpty ? defaultColorName : colorName
        return Image(name)
    }
    
    /// Top accessory
    var topImage: Image {
        topName.isEmpty ? Image("") : Image(topName)
    }
    
    /// Extra accessory
    var extraImage: Image {
        extraName.isEmpty ? Image("") : Image(extraName)
    }
    
    init() {
        loadCustomizations()
    }
    
    // Load user's saved customizations from Firestore
    func loadCustomizations() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
            .collection("Users' info")
            .document(uid)
            .getDocument { snap, _ in
                guard let data = snap?.data() else { return }
                
                // Only update on main thread to avoid UI issues
                DispatchQueue.main.async {
                    self.colorName = data["cow.color"] as? String ?? ""
                    self.topName = data["cow.top"] as? String ?? ""
                    self.extraName = data["cow.extra"] as? String ?? ""
                    
                    // Debug output to verify loading
                    print("✅ Loaded customizations: color=\(self.colorName), top=\(self.topName), extra=\(self.extraName)")
                }
            }
    }
    
    // Save user's customizations to Firestore
    func saveCustomizations() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let upd: [String:Any] = [
            "cow.color": colorName,
            "cow.top": topName,
            "cow.extra": extraName
        ]
        
        Firestore.firestore()
            .collection("Users' info")
            .document(uid)
            .updateData(upd) { error in
                if let error = error {
                    print("❌ Error saving customizations: \(error.localizedDescription)")
                } else {
                    print("✅ Saved customizations: color=\(self.colorName), top=\(self.topName), extra=\(self.extraName)")
                }
            }
    }
}
