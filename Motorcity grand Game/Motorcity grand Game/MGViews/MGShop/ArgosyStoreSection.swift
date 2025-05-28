import SwiftUI

enum ArgosyStoreSection: Codable, Hashable {
    case backgrounds
    case skin
}

class ArgosyShopViewModel: ObservableObject {
    @Published var shopTeamItems: [Item] = [
        
        Item(name: "bg1", image: "gameBg1Argosy", icon: "backIcon1Argosy", section: .backgrounds, price: 100),
        Item(name: "bg2", image: "gameBg2Argosy", icon: "backIcon2Argosy", section: .backgrounds, price: 100),
        Item(name: "bg3", image: "gameBg3Argosy", icon: "backIcon3Argosy", section: .backgrounds, price: 100),
        Item(name: "bg4", image: "gameBg4Argosy", icon: "backIcon4Argosy", section: .backgrounds, price: 100),
        
        
        Item(name: "skin1", image: "imageSkin1Argosy", icon: "iconSkin1Argosy", section: .skin, price: 100),
        Item(name: "skin2", image: "imageSkin2Argosy", icon: "iconSkin2Argosy", section: .skin, price: 100),
        Item(name: "skin3", image: "imageSkin3Argosy", icon: "iconSkin3Argosy", section: .skin, price: 100),
        Item(name: "skin4", image: "imageSkin4Argosy", icon: "iconSkin4Argosy", section: .skin, price: 100),
         
    ]
    
    @Published var boughtItems: [Item] = [
        Item(name: "bg1", image: "gameBg1Argosy", icon: "backIcon1Argosy", section: .backgrounds, price: 100),
        Item(name: "skin1", image: "imageSkin1Argosy", icon: "iconSkin1Argosy", section: .skin, price: 100),
    ] {
        didSet {
            saveBoughtItem()
        }
    }
    
    @Published var currentBgItem: Item? {
        didSet {
            saveCurrentBg()
        }
    }
    
    @Published var currentPersonItem: Item? {
        didSet {
            saveCurrentPerson()
        }
    }
    
    init() {
        loadCurrentBg()
        loadCurrentPerson()
        loadBoughtItem()
    }
    
    private let userDefaultsBgKey = "bgKeyArgosy"
    private let userDefaultsPersonKey = "skinsKeyArgosy"
    private let userDefaultsBoughtKey = "boughtItemsArgosy"

    
    func saveCurrentBg() {
        if let currentItem = currentBgItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsBgKey)
            }
        }
    }
    
    func loadCurrentBg() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBgKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentBgItem = loadedItem
        } else {
            currentBgItem = shopTeamItems[0]
            print("No saved data found")
        }
    }
    
    func saveCurrentPerson() {
        if let currentItem = currentPersonItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsPersonKey)
            }
        }
    }
    
    func loadCurrentPerson() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsPersonKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentPersonItem = loadedItem
        } else {
            currentPersonItem = shopTeamItems[4]
            print("No saved data found")
        }
    }
    
    func saveBoughtItem() {
        if let encodedData = try? JSONEncoder().encode(boughtItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsBoughtKey)
        }
        
    }
    
    func loadBoughtItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBoughtKey),
           let loadedItem = try? JSONDecoder().decode([Item].self, from: savedData) {
            boughtItems = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
}

struct Item: Codable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var icon: String
    var section: ArgosyStoreSection
    var price: Int
}
