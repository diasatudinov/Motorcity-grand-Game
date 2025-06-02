import SwiftUI

struct MGSettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var settingsVM: MGSettingsViewModel
    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        VStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                
                            } label: {
                                Image(.backIconMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 100:50)
                            }
                            
                            MGCoinBg().opacity(0)
                        }
                        Spacer()
                        Image(.settingsTextMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 210:105)
                        Spacer()
                        MGCoinBg()
                    }.padding([.top])
                }
                
                Spacer()
                HStack(spacing: 40) {
                    
                    VStack {
                        
                        Image(.soundTextMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                        
                        
                        HStack {
                            
                            Button {
                                withAnimation {
                                    settingsVM.soundEnabled.toggle()
                                }
                            } label: {
                                
                                Image(.arrowLeftMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                            }
                            
                            Image(settingsVM.soundEnabled ? .onMG:.offMG)
                                .resizable()
                                .scaledToFit()
                                .frame(width: MGDeviceManager.shared.deviceType == .pad ? 200:100, height: MGDeviceManager.shared.deviceType == .pad ? 140:70)
                            
                            Button {
                                withAnimation {
                                    settingsVM.soundEnabled.toggle()
                                }
                            } label: {
                                
                                Image(.arrowLeftMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                                    .scaleEffect(x: -1, y: 1)
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    VStack {
                        
                        Image(.languageTextMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                        
                        
                        HStack {
                            
                            
                            
                            Image(.arrowLeftMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                            
                            
                            Image(.flag1MG)
                                .resizable()
                                .scaledToFit()
                                .frame(width: MGDeviceManager.shared.deviceType == .pad ? 200:100, height: MGDeviceManager.shared.deviceType == .pad ? 140:70)
                            
                            
                            
                            Image(.arrowLeftMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 130:65)
                                .scaleEffect(x: -1, y: 1)
                            
                            
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
    }
    
}

#Preview {
    MGSettingsView(settingsVM: MGSettingsViewModel())
}
