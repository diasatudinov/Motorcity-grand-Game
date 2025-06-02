import SwiftUI

struct MGFindSequenceView: View {
    @StateObject var user = MGUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    let cardImages = [
        "sequenceCardFace1MG",
        "sequenceCardFace2MG",
        "sequenceCardFace3MG",
        "sequenceCardFace4MG",
        "sequenceCardFace5MG",
        "sequenceCardFace6MG",
        "sequenceCardFace7MG"
    ]
    let sequenceLength = 3
    
    @State private var sequence: [Int] = []
    @State private var currentStep: Int? = nil
    @State private var gamePhase: GamePhase = .showing
    @State private var userInputIndex = 0
    @State private var feedback: String? = nil
    
    enum GamePhase {
        case showing
        case userTurn
        case finished
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack {
                        HStack(alignment: .top) {
                            HStack {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                    
                                } label: {
                                    Image(.backIconMG)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: MGDeviceManager.shared.deviceType == .pad ? 100:50)
                                }
                                
                            }
                            Spacer()
                            
                            MGCoinBg()
                        }.padding([.horizontal, .top])
                    }
                }
                
                Image(.findSequenceGameTextMG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 180:90)
                
                Spacer()
                
                if gamePhase == .showing {
                    // Full-screen reveal of each card in sequence
                    if let idx = currentStep {
                        MemorizationCardView(imageName: cardImages[idx])
                            .frame(height: MGDeviceManager.shared.deviceType == .pad ? 340:170)
                            .padding()
                            .transition(.opacity)
                    }
                } else {
                    // Grid for user interaction
                    HStack(spacing: 12) {
                        ForEach(0..<cardImages.count, id: \.self) { index in
                            MemorizationCardView(imageName: cardImages[index])
                                .onTapGesture {
                                    handleTap(on: index)
                                }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                
            }
            
            if gamePhase == .finished {
                
                if userInputIndex >= sequenceLength {
                    ZStack {
                        VStack() {
                            Image(.sequebceCorrectTextMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:125)
                            
                            Image(.winTwentyMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 120:60)
                            
                            Spacer()
                            Button {
                                startGame()
                            } label: {
                                Image(.takeTextMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 120:60)
                            }
                        }
                    }
                } else {
                    ZStack {
                        VStack {
                            Image(.sequebceWrongTextMG)
                                .resizable()
                                .scaledToFit()
                                .frame(height: MGDeviceManager.shared.deviceType == .pad ? 250:125)
                            
                            Spacer()
                            
                            Button {
                                startGame()
                            } label: {
                                Image(.retreTextMG)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: MGDeviceManager.shared.deviceType == .pad ? 120:60)
                            }
                        }
                    }
                }
                
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
        .onAppear {
            startGame()
        }
        .animation(.easeInOut, value: currentStep)
    }
    
    private var headerText: String {
        switch gamePhase {
        case .showing:
            return "Watch the sequence..."
        case .userTurn:
            return "Your turn: repeat the sequence"
        case .finished:
            return feedback ?? ""
        }
    }
    
    private func startGame() {
        sequence = Array(0..<cardImages.count).shuffled().prefix(sequenceLength).map { $0 }
        userInputIndex = 0
        feedback = nil
        gamePhase = .showing
        currentStep = nil
        
        Task {
            await revealSequence()
        }
    }
    
    @MainActor
    private func revealSequence() async {
        for idx in sequence {
            currentStep = idx
            try? await Task.sleep(nanoseconds: 800_000_000)
            currentStep = nil
            try? await Task.sleep(nanoseconds: 300_000_000)
        }
        gamePhase = .userTurn
    }
    
    private func handleTap(on index: Int) {
        guard gamePhase == .userTurn else { return }
        if index == sequence[userInputIndex] {
            userInputIndex += 1
            if userInputIndex >= sequenceLength {
                feedback = "Correct! You win!"
                user.updateUserMoney(for: 20)
                gamePhase = .finished
                
            }
        } else {
            feedback = "Wrong! Try again."
            gamePhase = .finished
        }
    }
}

struct MemorizationCardView: View {
    let imageName: String
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}


#Preview {
    MGFindSequenceView()
}
