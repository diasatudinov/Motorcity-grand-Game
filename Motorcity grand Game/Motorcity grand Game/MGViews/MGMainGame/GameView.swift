//
//  GameView.swift
//  Motorcity grand Game
//
//  Created by Dias Atudinov on 27.05.2025.
//


import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}
