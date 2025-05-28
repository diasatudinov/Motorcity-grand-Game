import SwiftUI

class ArgosyAchievementsViewModel: ObservableObject {
    
    @Published var achievements: [AchievementSG] = [
        AchievementSG(image: "achieve1ImageMG", isAchieved: false),
        AchievementSG(image: "achieve2ImageMG", isAchieved: false),
        AchievementSG(image: "achieve3ImageMG", isAchieved: false),
        AchievementSG(image: "achieve4ImageMG", isAchieved: false),
        AchievementSG(image: "achieve5ImageMG", isAchieved: false)

    ] {
        didSet {
            saveAchievementsItem()
        }
    }
    
    init() {
        loadAchievementsItem()
        
    }
    
    private let userDefaultsAchievementsKey = "achievementsKeySG"
    
    func achieveToggle(_ achive: AchievementSG) {
        guard let index = achievements.firstIndex(where: { $0.id == achive.id })
        else {
            return
        }
        achievements[index].isAchieved.toggle()
        
    }
    
    
    func saveAchievementsItem() {
        if let encodedData = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsAchievementsKey)
        }
        
    }
    
    func loadAchievementsItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsAchievementsKey),
           let loadedItem = try? JSONDecoder().decode([AchievementSG].self, from: savedData) {
            achievements = loadedItem
        } else {
            print("No saved data found")
        }
    }
}

struct AchievementSG: Codable, Hashable, Identifiable {
    var id = UUID()
    var image: String
    var isAchieved: Bool
}
