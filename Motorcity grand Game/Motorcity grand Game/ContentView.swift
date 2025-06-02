import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var winner: String? = nil
    @State private var sendPercentage: CGFloat = 1.0
    var scene: MGGameScene {
        let scene = MGGameScene()
        scene.victoryHandler = { name in
            DispatchQueue.main.async {
                self.winner = name
            }
        }
        //scene.sendPercentage = sendPercentage
        return scene
    }
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onChange(of: sendPercentage) { newVal in
                   // scene.sendPercentage = newVal
                }
            
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    Button("25%") { sendPercentage = 0.25 }
                    Button("50%") { sendPercentage = 0.5 }
                    Button("75%") { sendPercentage = 0.75 }
                    Button("100%") { sendPercentage = 1.0 }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
            }
            
            if let winner = winner {
                Text("Команда \(winner) выиграла!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
