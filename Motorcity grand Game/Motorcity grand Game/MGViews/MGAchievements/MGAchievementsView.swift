import SwiftUI

struct MGAchievementsView: View {
    @StateObject var user = ArgosyUser.shared
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: ArgosyAchievementsViewModel
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
                        Image(.archieveTextMG)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 210:105)
                        Spacer()
                        ArgosyCoinBg()
                    }.padding([.top])
                }
                
               
                Spacer()
                HStack {
                    ForEach(viewModel.achievements, id: \.self) { achieve in
                        achievementItem(item: achieve)
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
    
    @ViewBuilder func achievementItem(item: AchievementSG) -> some View {
        VStack(spacing: 0) {
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 400:200)
                .opacity(item.isAchieved ? 1:0.5)
            
            Button {
                if !item.isAchieved {
                    user.updateUserMoney(for: 100)
                }
                    viewModel.achieveToggle(item)
                
            } label: {
                Image(.priceHundredMG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
            }
        }
    }
    
}


#Preview {
    MGAchievementsView(viewModel: ArgosyAchievementsViewModel())
}
