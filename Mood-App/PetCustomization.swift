
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class PetCustomization: ObservableObject {
    private let outlineImageName = "OUTLINE"
    var outlineImage: Image { Image(outlineImageName) }

    private let defaultColorName = "defaultcow"

    @Published var colorName: String = ""
    @Published var topName: String = ""
    @Published var extraName: String = ""
    @Published var pantsName: String = ""
    @Published var unlockedItems: Set<String> = ["defaultcow"]

    private var listener: ListenerRegistration?
    private let unlockCost = 50
    private let lockedCost = 50

    var colorcow: Image {
        let name = colorName.isEmpty ? defaultColorName : colorName
        return Image(name)
    }

    var topImage: Image {
        topName.isEmpty ? Image("") : Image(topName)
    }

    var extraImage: Image {
        extraName.isEmpty ? Image("") : Image(extraName)
    }

    var pantsImage: Image {
        pantsName.isEmpty ? Image("") : Image(pantsName)
    }

    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.listener?.remove()
            if let uid = user?.uid {
                self.ensureCowDefaults(uid: uid)
                self.startListening(uid: uid)
            } else {
                DispatchQueue.main.async {
                    self.colorName = ""
                    self.topName = ""
                    self.extraName = ""
                    self.pantsName = ""
                    self.unlockedItems = ["defaultcow"]
                }
            }
        }
    }

    private func ensureCowDefaults(uid: String) {
        let docRef = Firestore.firestore().collection("Users' info").document(uid)
        docRef.getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            let cow = data["cow"] as? [String: Any] ?? [:]
            var updates: [String: Any] = [:]
            if cow["color"] == nil { updates["cow.color"] = "defaultcow" }
            if cow["top"] == nil { updates["cow.top"] = "" }
            if cow["extra"] == nil { updates["cow.extra"] = "" }
            if cow["pants"] == nil { updates["cow.pants"] = "" }
            if data["unlockedItems"] == nil {
                updates["unlockedItems"] = ["defaultcow"]
            }
            if !updates.isEmpty {
                docRef.updateData(updates)
            }
        }
    }

    private func startListening(uid: String) {
        listener = Firestore.firestore()
            .collection("Users' info")
            .document(uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let snap = snapshot else { return }
                if snap.metadata.hasPendingWrites { return }
                let data = snap.data() ?? [:]
                let cow = data["cow"] as? [String: Any] ?? [:]
                DispatchQueue.main.async {
                    self.colorName = cow["color"] as? String ?? ""
                    self.topName   = cow["top"] as? String ?? ""
                    self.extraName = cow["extra"] as? String ?? ""
                    self.pantsName = cow["pants"] as? String ?? ""
                    if let unlocked = data["unlockedItems"] as? [String] {
                        self.unlockedItems = Set(unlocked)
                    }
                }
            }
    }

    func fetchInitialCustomizations() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection("Users' info").document(uid)
        docRef.getDocument { [weak self] snapshot, _ in
            guard let data = snapshot?.data(), let self = self else { return }
            let cow = data["cow"] as? [String: Any] ?? [:]
            DispatchQueue.main.async {
                self.colorName = cow["color"] as? String ?? ""
                self.topName   = cow["top"] as? String ?? ""
                self.extraName = cow["extra"] as? String ?? ""
                self.pantsName = cow["pants"] as? String ?? ""
                if let unlocked = data["unlockedItems"] as? [String] {
                    self.unlockedItems = Set(unlocked)
                }
            }
        }
    }

    func updateColor(_ name: String) {
        guard unlockedItems.contains(name) else { return }
        self.colorName = name
        updateField("color", value: name)
    }

    func updateTop(_ name: String) {
        guard unlockedItems.contains(name) else { return }
        self.topName = name
        updateField("top", value: name)
    }
    
    func updatePants(_ name: String) {
        guard unlockedItems.contains(name) else { return }
        self.pantsName = name
        updateField("pants", value: name)
    }


    func updateExtra(_ name: String) {
        guard unlockedItems.contains(name) else { return }
        self.extraName = name
        updateField("extra", value: name)
    }

    
    private func updateField(_ key: String, value: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let cowKey = "cow." + key
        Firestore.firestore()
            .collection("Users' info")
            .document(uid)
            .updateData([cowKey: value]) { error in
                if let e = error {
                    print("❌ Failed updating \(cowKey): \(e)")
                }
            }
    }

    func saveUserCustomizations() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let cowData: [String: Any] = [
            "color": colorName.isEmpty ? defaultColorName : colorName,
            "top": topName,
            "extra": extraName,
            "pants": pantsName
        ]

        Firestore.firestore()
            .collection("Users' info")
            .document(uid)
            .updateData(["cow": cowData]) { error in
                if let e = error {
                    print("❌ Failed saving customizations: \(e)")
                } else {
                    print("✅ Customizations saved successfully")
                }
            }
    }

    func unlockItem(_ item: String, storeData: StoreData, completion: ((Bool) -> Void)? = nil) {
        guard !unlockedItems.contains(item) else { completion?(true); return }
        if storeData.totalPoints >= unlockCost {
            storeData.deductPoints(unlockCost)
            let newSet = unlockedItems.union([item])
            self.unlockedItems = newSet
            guard let uid = Auth.auth().currentUser?.uid else { completion?(false); return }
            Firestore.firestore()
                .collection("Users' info")
                .document(uid)
                .updateData(["unlockedItems": Array(newSet)]) { error in
                    if let e = error {
                        print("❌ Failed unlocking item: \(e)")
                        completion?(false)
                    } else {
                        completion?(true)
                    }
                }
        } else {
            completion?(false)
        }
    }

    deinit {
        listener?.remove()
    }
}
