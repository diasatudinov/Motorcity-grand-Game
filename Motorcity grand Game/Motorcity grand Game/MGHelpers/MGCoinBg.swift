import SwiftUI

struct MGCoinBg: View {
    @StateObject var user = MGUser.shared
    var body: some View {
        ZStack {
            Image(.coinsBgMG)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: MGDeviceManager.shared.deviceType == .pad ? 42:21, weight: .semibold))
                .foregroundStyle(.yellow)
                .textCase(.uppercase)
                .offset(x: 20)
            
            
            
        }.frame(height: MGDeviceManager.shared.deviceType == .pad ? 100:50)
        
    }
}

#Preview {
    MGCoinBg()
}
