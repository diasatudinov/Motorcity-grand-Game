//
//  MGMainMenu.swift
//  Motorcity grand Game
//
//  Created by Dias Atudinov on 27.05.2025.
//

import SwiftUI

struct MGMainMenu: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchievement = false
    @State private var showMiniGames = false
    @State private var showSettings = false
    @State private var showCalendar = false

    
//    @StateObject var achievementVM = ArgosyAchievementsViewModel()
//    @StateObject var settingsVM = ArgosySettingsViewModel()
//    @StateObject var shopVM = ArgosyShopViewModel()
    
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
                    ArgosyCoinBg()
                        .opacity(0)
                    
                    Spacer()
                    
                    Image(.loadingLogoMG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 200:100)
                    Spacer()
                    
                    VStack {
                        
                        Button {
                            showSettings = true
                        } label: {
                            Image(.settingsIconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 178:89)
                        }
                        
                        ArgosyCoinBg()
                    }
                    
                }
                
                Button {
                    showGame = true
                } label: {
                    Image(.playIconMG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 240:126)
                }
                HStack {
                    
                    Button {
                        showMiniGames = true
                    } label: {
                        Image(.miniGamesIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 178:89)
                    }
                    
                    Button {
                        showShop = true
                    } label: {
                        Image(.shopIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 178:89)
                    }
                    
                    Button {
                        showAchievement = true
                    } label: {
                        Image(.achievementsIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 178:89)
                    }
                    
                    Button {
                        showCalendar = true
                    } label: {
                        Image(.calendarIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 178:89)
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
//            ArgosyChooseLevelView(shopVM: shopVM)
        }
        .fullScreenCover(isPresented: $showMiniGames) {
           // ArgosyChooseMiniGame()
        }
        .fullScreenCover(isPresented: $showAchievement) {
           // ArgosyAchievementsView(viewModel: achievementVM)
        }
        .fullScreenCover(isPresented: $showShop) {
          //  ArgosyShopView(viewModel: shopVM)
        }
        .fullScreenCover(isPresented: $showSettings) {
           // ArgosySettingsView(settingsVM: settingsVM)
        }
        
        
        
        
    }
    
}

#Preview {
    MGMainMenu()
}
