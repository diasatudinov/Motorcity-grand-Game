import SwiftUI

struct MGLevelsMainGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var shopVM: MGShopViewModel

    @State var openGame = false
    @State var selectedIndex = 0
    @State var tutorialPage = 0
    @AppStorage("firstOpen") var firstOpen = true
    var body: some View {
        ZStack {
            if !firstOpen {
                VStack {
                    ZStack {
                        HStack {
                            Image(.levelsTextMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 180:90)
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
                        }.padding([.horizontal, .top])
                        
                    }
                    
                    
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        
                        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 5)
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(0...9, id: \ .self) { index in
                                ZStack {
                                    Image(.levelNumBgMG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: MGDeviceManager.shared.deviceType == .pad ? 150:120)
                                    
                                    Text("\(index + 1)")
                                        .font(.system(size: MGDeviceManager.shared.deviceType == .pad ? 80:40, weight: .semibold))
                                        .foregroundStyle(.yellow)
                                }
                                .onTapGesture {
                                    selectedIndex = index
                                    DispatchQueue.main.async {
                                        openGame = true
                                    }
                                    
                                }
                            }
                        }.frame(width: MGDeviceManager.shared.deviceType == .pad ? 720:610)
                        
                    }
                    Spacer()
                    
                }
            } else {
                VStack {
                    HStack(alignment: .center) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(.homeIconMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 100:50)
                        }
                        Spacer()
                        Image(.tutorialLoader1MG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 50:25)
                        Spacer()
                        Image(.homeIconMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 100:50)
                            .opacity(0)
                    }.padding([.horizontal, .top])
                    Spacer()
                    HStack {
                        
                        VStack {
                            switch tutorialPage {
                            case 0:
                                Image(.tutorialInfo1MG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:150)
                            case 1:
                                Image(.tutorialInfo2MG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:150)
                            case 2:
                                Image(.tutorialInfo3MG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:150)
                            case 3:
                                Image(.tutorialInfo4MG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:150)
                            case 4:
                                Image(.tutorialInfo5MG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:150)
                            case 5:
                                Image(.tutorialInfo6MG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:150)
                            case 6:
                                Image(.tutorialInfo7MG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:150)
                            default:
                                Text("")
                            }
                            
                            Button {
                                if tutorialPage == 6 {
                                    firstOpen = false
                                }
                                
                                if tutorialPage < 6 {
                                    tutorialPage += 1
                                }
                         
                                
                            } label: {
                                if tutorialPage == 6 || tutorialPage == 2 {
                                    Image(.okTextMG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: MGDeviceManager.shared.deviceType == .pad ? 100:60)
                                } else {
                                    Image(.tutorialNextTextMG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: MGDeviceManager.shared.deviceType == .pad ? 100:60)
                                    
                                }
                            }
                        }
                        
                        switch tutorialPage {
                        case 0:
                            Image(.tutorialMap1MG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:250)
                            
                        case 1:
                            Image(.tutorialMap2MG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:250)
                        case 2:
                            Image(.tutorialMap2MG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:250)
                        case 3:
                            Image(.tutorialMap3MG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:250)
                        case 4:
                            Image(.tutorialMap4MG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:250)
                        case 5:
                            Image(.tutorialMap4MG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:250)
                        case 6:
                            Image(.tutorialMap4MG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:250)
                        default:
                            Text("")
                        }
                        
                        
                        
                        Image(.tutorialScale1MG)
                            .resizable()
                            .scaledToFit()
                            .frame(width: MGDeviceManager.shared.deviceType == .pad ? 400:200,height: MGDeviceManager.shared.deviceType == .pad ? 400:250)
                        
                    }
                    
                    Spacer()
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
        .fullScreenCover(isPresented: $openGame) {
             MGGameView(shopVM: shopVM, level: selectedIndex)
        }
    }

}

#Preview {
    MGLevelsMainGameView(shopVM: MGShopViewModel())
}
