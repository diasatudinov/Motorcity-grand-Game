import SwiftUI
import SpriteKit

struct ArgosyGameView: View {
    @Environment(\.presentationMode) var presentationMode
   
    @State var gameScene: GameScene = {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    @ObservedObject var shopVM: ArgosyShopViewModel
    @State private var powerUse = false
    @State private var isWin = false
    @State private var winner: String? = nil
    @State private var sendPercentage: CGFloat = 1.0
    @State private var score = 0
    @State var level: Int
    var body: some View {
        ZStack {
            ArgosySpriteViewContainer(scene: gameScene, winner: $winner, sendPercent: $sendPercentage, level: level)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        Spacer()
                        
                    }.padding([.horizontal, .top])
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                ZStack {
                    Image(.stickBgMG)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 500:250)
                    
                    VStack(spacing: 12) {
                        
                        Button { sendPercentage = 1.0
                            gameScene.sendPercent = sendPercentage
                        } label: {
                            ZStack {
                                Image(.persentBgMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 150:80)
                                
                                Text("Max")
                                    .font(.system(size: ArgosyDeviceManager.shared.deviceType == .pad ? 35:20, weight: .semibold))
                                    .foregroundStyle(.yellow)
                            }
                        }
                        
                        Button { sendPercentage = 0.75
                            gameScene.sendPercent = sendPercentage
                        } label: {
                            ZStack {
                                Image(.persentBgMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 150:80)
                                
                                Text("75%")
                                    .font(.system(size: ArgosyDeviceManager.shared.deviceType == .pad ? 35:20, weight: .semibold))
                                    .foregroundStyle(.yellow)
                            }
                        }
                        
                        Button { sendPercentage = 0.5
                            gameScene.sendPercent = sendPercentage
                        } label: {
                            ZStack {
                                Image(.persentBgMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 150:80)
                                
                                Text("50%")
                                    .font(.system(size: ArgosyDeviceManager.shared.deviceType == .pad ? 35:20, weight: .semibold))
                                    .foregroundStyle(.yellow)
                            }
                        }
                        
                        Button { sendPercentage = 0.25
                            gameScene.sendPercent = sendPercentage
                        } label: {
                            ZStack {
                                Image(.persentBgMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 150:80)
                                
                                Text("25%")
                                    .font(.system(size: ArgosyDeviceManager.shared.deviceType == .pad ? 35:20, weight: .semibold))
                                    .foregroundStyle(.yellow)
                            }
                        }
                        
                        
                        
                        
                    }
                    
                }.frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 600:300)
            }
            

            
            if let winner = winner {
                if winner == "синяя" {
                    ZStack {
                        Color.black.opacity(0.5).ignoresSafeArea()
                        
                        HStack {
                            
                            Image(.manImage1MG)
                                .resizable()
                                .scaledToFit()
                            
                            VStack {
                                Image(.winTextMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 400:200)
                                
                                Image(.priceFiftyMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 120:60)
                                
                                Button {
                                    gameScene.restartGame()
                                    self.winner = nil
                                    ArgosyUser.shared.updateUserMoney(for: 50)
                                } label: {
                                    Image(.takeTextMG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 120:60)
                                }
                                
                            }
                            
                            Image(.man2ImageMG)
                                .resizable()
                                .scaledToFit()
                        }.ignoresSafeArea()
                    }
                } else {
                    ZStack {
                        Color.black.opacity(0.5).ignoresSafeArea()
                        
                        HStack {
                            
                            VStack {
                                Image(.youLoseTextMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 200:120)
                               
                                
                                Button {
                                    gameScene.restartGame()
                                    self.winner = nil
                                } label: {
                                    Image(.retreTextMG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 120:60)
                                }
                                
                            }
                            
                            Image(.man2ImageMG)
                                .resizable()
                                .scaledToFit()
                        }.ignoresSafeArea()
                    }
                }
            }
            
            
        }.background(
            ZStack {
                if let item = shopVM.currentBgItem {
                    Image(item.image)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
            }
        )
    }
}

#Preview {
    ArgosyGameView(shopVM: ArgosyShopViewModel(), level: 1)
}
