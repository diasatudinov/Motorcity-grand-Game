import SwiftUI

struct MGSplashScreen: View {
    @State private var scale: CGFloat = 1.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer?
    var body: some View {
        ZStack {
            Image(.appBgMG)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
              
                
                Image(.loadingLogoMG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 110)
                
                Image(.textMG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 61)
                
                Image(.loadingTextMG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 55)
                    .scaleEffect(scale)
                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                        value: scale
                    )
                    .onAppear {
                        scale = 0.8
                    }
                    .padding(.bottom, 15)
                
                ZStack {
                   
                    Image(.loaderBgMG)
                        .resizable()
                        .scaledToFit()
                        .colorMultiply(.gray)
                    
                    Image(.loaderMG)
                        .resizable()
                        .scaledToFit()
                        .mask(
                            Rectangle()
                                .frame(width: progress * 600)
                                .padding(.trailing, (1 - progress) * 600)
                        )
                    
                }
                .frame(width: 600)
            }
            
            
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                progress += 0.01
            } else {
                timer.invalidate()
            }
        }
    }
}



#Preview {
    MGSplashScreen()
}
