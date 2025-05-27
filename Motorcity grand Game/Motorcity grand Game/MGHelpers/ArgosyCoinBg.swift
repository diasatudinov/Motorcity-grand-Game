import SwiftUI

struct ArgosyCoinBg: View {
    @StateObject var user = ArgosyUser.shared
    var body: some View {
        ZStack {
            Image(.coinsBgMG)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: ArgosyDeviceManager.shared.deviceType == .pad ? 42:21, weight: .semibold))
                .foregroundStyle(.yellow)
                .textCase(.uppercase)
                .offset(x: 20)
            
            
            
        }.frame(height: ArgosyDeviceManager.shared.deviceType == .pad ? 100:50)
        
    }
}

#Preview {
    ArgosyCoinBg()
}
