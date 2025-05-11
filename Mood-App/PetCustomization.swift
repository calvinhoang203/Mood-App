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
    
    
    private var listener: ListenerRegistration?
    
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
        // Whenever a user signs in/out, start or stop listening
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.listener?.remove()
            if let uid = user?.uid {
                self.startListening(uid: uid)
            }
        }
    }

    private func startListening(uid: String) {
        listener = Firestore.firestore()
            .collection("Users' info")
            .document(uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let snap = snapshot else { return }
                // ignore the “local-write” snapshot so we only update once the server has confirmed
                if snap.metadata.hasPendingWrites { return }
                let data = snap.data() ?? [:]
                DispatchQueue.main.async {
                    self.colorName = data["cow.color"] as? String ?? ""
                    self.topName   = data["cow.top"]   as? String ?? ""
                    self.extraName = data["cow.extra"] as? String ?? ""
                }
            }
    }

    
    // Call this when you want to force–fetch the three cow fields one time.
    func fetchInitialCustomizations() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore()
          .collection("Users' info")
          .document(uid)

        docRef.getDocument { [weak self] snapshot, _ in
            guard let data = snapshot?.data(), let self = self else { return }
            DispatchQueue.main.async {
                self.colorName = data["cow.color"] as? String ?? ""
                self.topName   = data["cow.top"]   as? String ?? ""
                self.extraName = data["cow.extra"] as? String ?? ""
            }
        }
    }
    
    // MARK: — Single‐field updaters

    func updateColor(_ name: String) {
        self.colorName = name
        updateField("cow.color", value: name)
    }

    func updateTop(_ name: String) {
        topName = name
        updateField("cow.top", value: name)
    }

    func updateExtra(_ name: String) {
        extraName = name
        updateField("cow.extra", value: name)
    }

    private func updateField(_ key: String, value: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
          .collection("Users' info")
          .document(uid)
          .updateData([key: value]) { error in
              if let e = error {
                  print("❌ Failed updating \(key): \(e)")
              }
          }
    }
    

    deinit {
        listener?.remove()
    }
}
