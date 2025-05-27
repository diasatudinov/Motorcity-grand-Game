import SpriteKit
import GameplayKit
import SwiftUI

// MARK: - GameScene
// MARK: - SpriteKit GameScene Implementation
class GameScene: SKScene {
    private var cells: [CellNode] = []
    private var players: [Player] = []
    private var selectedCell: CellNode?
    private var lastUpdateTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        physicsWorld.gravity = .zero
        setupPlayers()
        setupMap()
    }

    private func setupPlayers() {
        let human = Player(name: "Player", isHuman: true, color: .red)
        let bot = Player(name: "Bot", isHuman: false, color: .blue)
        players = [human, bot]
    }

    private func setupMap() {
        let positions = [
            CGPoint(x: 150, y: 300), CGPoint(x: 300, y: 500),
            CGPoint(x: 500, y: 300), CGPoint(x: 300, y: 100)
        ]
        for (i, pos) in positions.enumerated() {
            let owner: Player? = i < 2 ? players[i] : nil
            let cell = CellNode(id: i, position: pos, owner: owner)
            addChild(cell)
            cells.append(cell)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func update(_ currentTime: TimeInterval) {}
}


// MARK: - CellNode
class CellNode: SKShapeNode {
    let id: Int
    weak var owner: Player? {
        didSet { updateAppearance() }
    }
    private(set) var soldierCount: Int = 10 {
        didSet { countLabel.text = "\(soldierCount)" }
    }
    private var growthAccumulator: TimeInterval = 0
    private let countLabel = SKLabelNode(fontNamed: "Helvetica-Bold")

    init(id: Int, position: CGPoint, owner: Player?) {
        self.id = id
        self.owner = owner
        super.init()

        self.position = position
        let diameter: CGFloat = 60
        path = CGPath(ellipseIn: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter), transform: nil)
        lineWidth = 2
        name = "cell_\(id)"

        countLabel.fontSize = 18
        countLabel.verticalAlignmentMode = .center
        addChild(countLabel)

        updateAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func update(deltaTime: TimeInterval) {
        guard owner != nil else { return }
        growthAccumulator += deltaTime
        if growthAccumulator >= 1.0 {
            soldierCount += 1
            growthAccumulator = 0
        }
    }

    func setHighlight(_ highlighted: Bool) {
        let action = SKAction.scale(to: highlighted ? 1.2 : 1.0, duration: 0.1)
        run(action)
    }

    private func updateAppearance() {
        fillColor = owner?.color ?? .lightGray
        strokeColor = .darkGray
        countLabel.fontColor = owner != nil ? .white : .black
        countLabel.text = "\(soldierCount)"
    }

    func sendSoldiers(to target: CellNode) {
        let sendCount = soldierCount / 2
        guard sendCount > 0, let player = owner else { return }

        soldierCount -= sendCount
        for i in 0..<sendCount {
            let delay = TimeInterval(i) * 0.03
            let soldier = SoldierNode(owner: player)
            soldier.position = position
            scene?.addChild(soldier)
            soldier.move(to: target.position, after: delay) {
                target.receiveSoldier(from: player)
            }
        }
    }

    private func receiveSoldier(from attacker: Player) {
        if owner == attacker {
            soldierCount += 1
        } else {
            soldierCount -= 1
            if soldierCount < 0 {
                owner = attacker
                soldierCount = abs(soldierCount)
            }
        }
    }
}

// MARK: - SoldierNode
class SoldierNode: SKShapeNode {
    private let moveDuration: TimeInterval = 1.0

    init(owner: Player) {
        super.init()
        let size: CGFloat = 8
        path = CGPath(ellipseIn: CGRect(x: -size/2, y: -size/2, width: size, height: size), transform: nil)
        fillColor = owner.color
        strokeColor = .clear
        zPosition = 1
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func move(to destination: CGPoint, after delay: TimeInterval, completion: @escaping () -> Void) {
        let sequence = SKAction.sequence([
            .wait(forDuration: delay),
            .move(to: destination, duration: moveDuration),
            .run(completion),
            .removeFromParent()
        ])
        run(sequence)
    }
}

// MARK: - Player
class Player: Hashable {
    let name: String
    let isHuman: Bool
    let color: UIColor

    init(name: String, isHuman: Bool, color: UIColor) {
        self.name = name
        self.isHuman = isHuman
        self.color = color
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.name == rhs.name && lhs.color == rhs.color
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

// MARK: - Data Model for SwiftUI
struct CellData: Identifiable {
    let id: Int
    let position: CGPoint // координаты в SK-сцене
    let ownerColor: Color
    let soldierCount: Int? // nil для неизвестных
}

// MARK: - SwiftUI Map Overlay
struct MapOverlay: View {
    let cells: [CellData]

    var body: some View {
        GeometryReader { geo in
            ForEach(cells) { cell in
                // Переводим координаты из SKScene (origin bottom-left) в SwiftUI (top-left)
                let x = cell.position.x / UIScreen.main.bounds.width * geo.size.width
                let y = (1 - cell.position.y / UIScreen.main.bounds.height) * geo.size.height

                ZStack {
                    Circle()
                        .fill(cell.ownerColor)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                    if let count = cell.soldierCount {
                        HStack(spacing: 4) {
                            Image(systemName: "shield.fill")
                            Text("\(count)")
                                .font(.headline)
                                .bold()
                        }
                        .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                }
                .position(x: x, y: y)
            }
        }
    }
}
