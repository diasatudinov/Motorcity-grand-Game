import SwiftUI

struct MGDailyTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    
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
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
                            }
                            
                            ArgosyCoinBg().opacity(0)
                        }
                        
                        Spacer()
                        Image(.dailyTaskTextMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 210:120)
                        Spacer()
                        
                        ArgosyCoinBg()
                    }.padding(.top)
                }
                
                HStack {
                    
                    ZStack {
                        Image(.task1ImageMG)
                            .resizable()
                            .scaledToFit()
                        
                        
                        VStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Image(.priceFiftyMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 110:55)
                            }
                        }
                        
                    }.frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 210:250)
                    
                    ZStack {
                        Image(.task2ImageMG)
                            .resizable()
                            .scaledToFit()
                        
                        
                        VStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Image(.priceFiftyMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 110:55)
                            }
                        }
                        
                    }.frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 210:250)
                    
                    ZStack {
                        Image(.task3ImageMG)
                            .resizable()
                            .scaledToFit()
                        
                        
                        VStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Image(.priceFiftyMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 110:55)
                            }
                        }
                        
                    }.frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 210:250)
                }.offset(y: -25)
                
                
            }
            
        }
        .background(
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
    MGDailyTaskView()
}
