import SwiftUI
import SpriteKit

struct MGMazeGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isWin = false
    @State private var gameScene: MGMazeScene = {
        let scene = MGMazeScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    @State private var powerUse = false
    
    var body: some View {
        ZStack {
            
            MGMazeViewContainer(scene: gameScene, isWin: $isWin)
            
            VStack {
                ZStack {
                    
                    HStack(alignment: .top) {
                        Image(.mazeTextMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 180:91)
                    }
                    
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        
                        Spacer()
                        
                        MGCoinBg()
                        
                    }.padding([.top])
                    
                }
                
                Spacer()
                HStack {
                    VStack {
                        ZStack {
                            Image(.numBgMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:150)
                            
                            Text("Tries: 1")
                                .font(.system(size: 23, weight: .semibold))
                                .foregroundStyle(.yellow)
                        }
                        
                        Button {
                            gameScene.restartGame()
                            isWin = false
                        } label: {
                            Image(.restartBtnMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                        }
                    }
                    Spacer()
                VStack(spacing: 0) {
                    Spacer()
                    Button {
                        gameScene.moveUp()
                        
                    } label: {
                        Image(.controlArrowMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                    }
                    HStack(spacing: MGDeviceManager.shared.deviceType == .pad ? 100:50) {
                        Button {
                            gameScene.moveLeft()
                        } label: {
                            Image(.controlArrowMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                                .rotationEffect(.degrees(90))
                                .scaleEffect(x: -1, y: 1)
                        }
                        
                        Button {
                            gameScene.moveRight()
                        } label: {
                            Image(.controlArrowMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                                .rotationEffect(.degrees(90))
                        }
                    }
                    
                    Button {
                        gameScene.moveDown()
                    } label: {
                        Image(.controlArrowMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                            .scaleEffect(x: 1, y: -1)
                    }
                    Spacer()
                }
                }.padding(.horizontal)
                
            }
            
            if isWin {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    VStack(spacing: -10) {
                        
                        Image(.wayFoundTextMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 210:105)
                    
                        
                        Image(.winTwentyMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 120:60)
                        
                        Spacer()
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            MGUser.shared.updateUserMoney(for: 20)

                        } label: {
                            Image(.takeTextMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 120:60)
                        }
                    }
                }
            }
            
        }.background(
            ZStack {
                Image(.appBgMG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
    }
}

#Preview {
    MGMazeGameView()
}
