import SwiftUI
import SpriteKit

struct ArgosyMazeGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isWin = false
    @State private var gameScene: ArgosyMazeScene = {
        let scene = ArgosyMazeScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    @State private var powerUse = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Image(.guessTheNumTextArgosy)
                    .resizable()
                    .scaledToFit()
                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 210:105)
                Image(.guessNumGameBgArgosy)
                    .resizable()
                    .scaledToFit()
            }
            ArgosyMazeViewContainer(scene: gameScene, isWin: $isWin)
                
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.backIconArgosy)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        
                        Spacer()
                        
                        ArgosyCoinBg()

                    }.padding([.horizontal, .top])
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Button {
                        gameScene.moveUp()
                        
                    } label: {
                        Image(.controlArrowArgosy)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
                    }
                    HStack(spacing: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50) {
                        Button {
                            gameScene.moveLeft()
                        } label: {
                            Image(.controlArrowArgosy)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
                                .rotationEffect(.degrees(90))
                                .scaleEffect(x: -1, y: 1)
                        }
                        
                        Button {
                            gameScene.moveRight()
                        } label: {
                            Image(.controlArrowArgosy)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
                                .rotationEffect(.degrees(90))
                        }
                    }
                    
                    Button {
                        gameScene.moveDown()
                    } label: {
                        Image(.controlArrowArgosy)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
                            .scaleEffect(x: 1, y: -1)
                    }
                }.padding(.bottom, 50)
                
                
            }
            
            if isWin {
                ZStack {
                    VStack(spacing: ArgosyDeviceManager.shared.deviceType == .pad ? -60:-30) {
                        Image(.winTextArgosy)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 500:250)
                        
                        Button {
                            gameScene.restartGame()
                            isWin = false
                        } label: {
                            Image(.getTextArgosy)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 120:60)
                        }
                    }
                }
            }
            
        }.background(
            ZStack {
                Image(.appBgArgosy)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
    }
}

#Preview {
    ArgosyMazeGameView()
}
