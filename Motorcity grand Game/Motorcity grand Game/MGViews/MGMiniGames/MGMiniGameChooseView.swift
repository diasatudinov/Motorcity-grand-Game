import SwiftUI

struct MGMiniGameChooseView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var game1 = false
    @State private var game2 = false
    @State private var game3 = false
    @State private var game4 = false
    var body: some View {
        ZStack {
            VStack {
                HStack {
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
                    }.padding([.horizontal, .top])
                    
                }
                
                Spacer()
                
                VStack(spacing: 13) {
                    
                    HStack {
                        Button {
                            game1 = true
                        } label: {
                            Image(.game1IconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 180:90)
                            
                        }
                        
                        Button {
                            game2 = true
                        } label: {
                            Image(.game2IconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 180:90)
                            
                        }
                    }
                    
                    HStack {
                        Button {
                            game3 = true
                        } label: {
                            Image(.game3IconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 180:90)
                            
                        }
                        
                        Button {
                            game4 = true
                        } label: {
                            Image(.game4IconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 180:90)
                            
                        }
                    }
                }
                
                Spacer()
                
            }
        }.background(
            ZStack {
                Image(.appBgMG)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .fullScreenCover(isPresented: $game1) {
            MGGuessNumberView()
        }
        .fullScreenCover(isPresented: $game2) {
            MGFindSequenceView()
        }
        .fullScreenCover(isPresented: $game3) {
            MGMazeGameView()
        }
        .fullScreenCover(isPresented: $game4) {
            MGMatchTheCardView()
            
        }
    }
}

#Preview {
    MGMiniGameChooseView()
}
