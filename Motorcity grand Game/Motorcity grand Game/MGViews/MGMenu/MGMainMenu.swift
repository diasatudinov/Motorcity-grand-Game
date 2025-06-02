import SwiftUI

struct MGMainMenu: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchievement = false
    @State private var showMiniGames = false
    @State private var showSettings = false
    @State private var showCalendar = false

    
    @StateObject var achievementVM = MGAchievementsViewModel()
    @StateObject var settingsVM = MGSettingsViewModel()
    @StateObject var shopVM = MGShopViewModel()
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Image(.manImage1MG)
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                    
                    Spacer()
                }
            }
            
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    MGCoinBg()
                        .opacity(0)
                    
                    Spacer()
                    
                    Image(.loadingLogoMG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: MGDeviceManager.shared.deviceType == .pad ? 200:100)
                    Spacer()
                    
                    VStack {
                        
                        Button {
                            showSettings = true
                        } label: {
                            Image(.settingsIconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 178:89)
                        }
                        
                        MGCoinBg()
                    }
                    
                }
                
                Button {
                    showGame = true
                } label: {
                    Image(.playIconMG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: MGDeviceManager.shared.deviceType == .pad ? 240:126)
                }
                HStack {
                    
                    Button {
                        showMiniGames = true
                    } label: {
                        Image(.miniGamesIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 178:89)
                    }
                    
                    Button {
                        showShop = true
                    } label: {
                        Image(.shopIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 178:89)
                    }
                    
                    Button {
                        showAchievement = true
                    } label: {
                        Image(.achievementsIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 178:89)
                    }
                    
                    Button {
                        showCalendar = true
                    } label: {
                        Image(.calendarIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 178:89)
                    }
                    
                    
                }
                
            }.padding()
            
        }
        .background(
            ZStack {
                Image(.appBgMG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .fullScreenCover(isPresented: $showGame) {
            MGLevelsMainGameView(shopVM: shopVM)
        }
        .fullScreenCover(isPresented: $showMiniGames) {
            MGMiniGameChooseView()
        }
        .fullScreenCover(isPresented: $showAchievement) {
            MGAchievementsView(viewModel: achievementVM)
        }
        .fullScreenCover(isPresented: $showShop) {
            MGShopView(viewModel: shopVM)
        }
        .fullScreenCover(isPresented: $showSettings) {
            MGSettingsView(settingsVM: settingsVM)
        }
        .fullScreenCover(isPresented: $showCalendar) {
            MGDailyTaskView()
        }
        
        
        
        
    }
    
}

#Preview {
    MGMainMenu()
}
