import SwiftUI

struct MGGuessNumberView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = MGUser.shared
    @State private var target = Int.random(in: 100...999)
    @State private var guessDigits: [String] = []
    @State private var feedback: String = ""
    @State private var attempts = 0
    
    private let padNumbers = [1, 2, 3,
                              4, 5, 6,
                              7, 8, 9,
                              0]
    

        var body: some View {
            ZStack {
                if Int(guessDigits.joined()) ?? 0 != target {
                    VStack(spacing: MGDeviceManager.shared.deviceType == .pad ? 40:20) {
                        Spacer()
                        
                        ZStack {
                            
                            VStack {
                                
                                ZStack {
                                    
                                    Image(.numBgMG)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    HStack(spacing: 5) {
                                        ForEach(0..<3) { idx in
                                            ZStack {
                                                
                                                Text(idx < guessDigits.count ? guessDigits[idx] : "" )
                                                    .font(.system(size: 36, weight: .bold))
                                                    .foregroundColor(.white)
                                            }.frame(width: MGDeviceManager.shared.deviceType == .pad ? 40:20, height: MGDeviceManager.shared.deviceType == .pad ? 150:83)
                                        }
                                    }
                                    
                                    
                                }.frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:255)
                                
                                let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
                                HStack(spacing: MGDeviceManager.shared.deviceType == .pad ? 12:12) {
                                    ForEach(padNumbers, id: \ .self) { num in
                                        Button(action: { numberPressed(num) }) {
                                            ZStack {
                                                Image(.numberEnterBgMG)
                                                    .resizable()
                                                    .scaledToFit()
                                                Text("\(num)")
                                                    .font(.system(size: MGDeviceManager.shared.deviceType == .pad ? 50:36, weight: .bold))
                                                    .foregroundColor(.yellow)
                                            }.frame(width: MGDeviceManager.shared.deviceType == .pad ? 100:72, height: MGDeviceManager.shared.deviceType == .pad ? 100:72)
                                        }
                                        .disabled(guessDigits.count >= 3)
                                    }
                                }.frame(width: MGDeviceManager.shared.deviceType == .pad ? 480:200)
                                    .padding(.horizontal)
                            }
                        }.padding()
                        
                        Spacer()
                    }
                }
                
                if !feedback.isEmpty {
                    Text(feedback)
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .padding(.bottom, 10)
                        .shadow(radius: 2)
                    
                    ZStack {
                        
                        if Int(guessDigits.joined()) ?? 0 < target {
                            Image(.biggerTextMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:125)
                        } else if Int(guessDigits.joined()) ?? 0 > target {
                            Image(.smallerTextMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:125)
                        } else {
                            ZStack {
                                VStack(spacing: -10) {
                                    
                                    Image(.guessTheNumTextMG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: MGDeviceManager.shared.deviceType == .pad ? 210:105)
                                    
                                    ZStack {
                                        
                                        Image(.numBgMG)
                                            .resizable()
                                            .scaledToFit()
                                        
                                        Text("\(target)")
                                            .font(.system(size: 42, weight: .semibold))
                                            .foregroundStyle(.green)
                                        
                                        
                                    }.frame(height: MGDeviceManager.shared.deviceType == .pad ? 400:200)
                                    
                                    Image(.winTwentyMG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: MGDeviceManager.shared.deviceType == .pad ? 120:60)
                                    
                                    Button {
                                        resetGame()
                                        user.updateUserMoney(for: 20)
                                    } label: {
                                        Image(.takeTextMG)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 120:60)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
                VStack {
                    ZStack {
                        HStack {
                            Image(.guessTheNumTextMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 210:105)
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
                }.padding()
            }.background(
                ZStack {
                    Image(.appBgMG)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
            )
        }

    private func numberPressed(_ num: Int) {
        guard guessDigits.count < 3 else { return }
        guessDigits.append("\(num)")
        if guessDigits.count == 3 {
            evaluateGuess()
        }
    }

    private func evaluateGuess() {
        let guess = Int(guessDigits.joined()) ?? 0
        attempts += 1
        if guess < target {
            feedback = "Too low!"
        } else if guess > target {
            feedback = "Too high!"
        } else {
            feedback = "You got it in \(attempts) tries!"
            MGUser.shared.updateUserMoney(for: 100)
        }
        if feedback.starts(with: "You got it") {
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // clear digits but keep target and attempts
                guessDigits = []
                feedback = ""
            }
        }
    }

    private func resetGame() {
        target = Int.random(in: 100...999)
        guessDigits = []
        feedback = ""
        attempts = 0
    }
}

#Preview {
    MGGuessNumberView()
}
