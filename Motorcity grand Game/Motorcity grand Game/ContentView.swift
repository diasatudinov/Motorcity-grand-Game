import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

       var body: some View {
           ZStack {
               // SpriteKit Game
               GameView()
                   .edgesIgnoringSafeArea(.all)

               // Overlay SwiftUI карта
               MapOverlay(cells: viewModel.cells)
                   .allowsHitTesting(false)
           }
       }
   }
#Preview {
    ContentView()
}
