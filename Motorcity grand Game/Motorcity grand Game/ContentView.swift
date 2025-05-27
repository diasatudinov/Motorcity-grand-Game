//
//  ContentView.swift
//  Motorcity grand Game
//
//  Created by Dias Atudinov on 27.05.2025.
//

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
