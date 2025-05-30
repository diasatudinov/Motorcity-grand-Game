import SpriteKit
import GameplayKit
import SwiftUI

let positions: [CGPoint] = [
    CGPoint(x: 530, y: 210),
    CGPoint(x: 290, y: 165),
    CGPoint(x: 320, y: 330),
    CGPoint(x: 475, y: 345),
    CGPoint(x: 410, y: 322),
    CGPoint(x: 406, y: 240),
    CGPoint(x: 478, y: 260),
    CGPoint(x: 525, y: 140)

]

#Preview {
    ContentView()
}

class GameScene: SKScene {
    var victoryHandler: ((String) -> Void)?
    var sendPercent: CGFloat?
    var levelIndex: Int?
    private var cells: [TerritoryNode] = []
    private var players: [Player] = []
    private var selectedCell: TerritoryNode?
    private var lastUpdateTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        anchorPoint = .zero
        size = view.bounds.size
        backgroundColor = .clear
        setupPlayers()
        setupMap()
        scheduleBotTurns()
    }

    private func setupPlayers() {
        let human = Player(name: "Player", isHuman: true, color: .blue)
        let bot   = Player(name: "Bot",    isHuman: false, color: .red)
        players = [human, bot]
    }

    private func setupMap() {
        let textures = (0..<8).map { SKTexture(imageNamed: "mask\($0)") }
        let positions: [CGPoint] = [
            CGPoint(x: 530, y: 210),
            CGPoint(x: 290, y: 165),
            CGPoint(x: 320, y: 330),
            CGPoint(x: 475, y: 345),
            CGPoint(x: 410, y: 322),
            CGPoint(x: 406, y: 240),
            CGPoint(x: 478, y: 260),
            CGPoint(x: 525, y: 140)
        ]
        let owners: [Player?] = [players[0], players[1]] + Array(repeating: nil, count: 6)

        for i in 0..<textures.count {
            let node = TerritoryNode(
                id: i,
                texture: textures[i],
                position: positions[i],
                owner: owners[i]
            )
            addChild(node)
            cells.append(node)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
        for cell in cells {
            if cell.owner?.isHuman == true && cell.contains(loc) {
                selectedCell = cell
                cell.setHighlight(true)
                break
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self),
              let from = selectedCell else { return }
        for cell in cells where cell !== from {
            if cell.contains(loc) {
                if let sendPercent = sendPercent {
                    from.sendSoldiers(to: cell, sendPercentage: sendPercent)
                }
                break
            }
        }
        from.setHighlight(false)
        selectedCell = nil
    }

    override func update(_ currentTime: TimeInterval) {
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        cells.forEach { $0.update(deltaTime: dt) }
        checkVictory()
    }
    
    // MARK: - Victory Check
    private func checkVictory() {
        // Если у синей стороны нет территорий, она проигрывает, побеждают красные
        let blueExists = cells.contains { $0.owner?.isHuman == true }
        if !blueExists {
            victoryHandler?("красная")
            isUserInteractionEnabled = false
            removeAllActions()
            return
        }
        // Если у красной стороны нет территорий, она проигрывает, побеждают синие
        let redExists = cells.contains { $0.owner?.isHuman == false }
        if !redExists {
            victoryHandler?("синяя")
            isUserInteractionEnabled = false
            removeAllActions()
        }
    }
    
    func restartGame() {
        // Stop all actions and clear nodes
        removeAllActions()
        children.forEach { $0.removeFromParent() }
        cells.removeAll()
        selectedCell = nil
        lastUpdateTime = 0
        
        // Reinitialize players and map
        setupPlayers()
        setupMap()
        
        // Restart AI turns and allow input
        isUserInteractionEnabled = true
        scheduleBotTurns()
    }

    // MARK: — Bot AI
    private func scheduleBotTurns() {
        let wait = SKAction.wait(forDuration: 2.0)
        let action = SKAction.run { [weak self] in self?.botTurn() }
        run(SKAction.repeatForever(SKAction.sequence([wait, action])))
    }

    private func botTurn() {
        let botCells = cells.filter { $0.owner?.isHuman == false && $0.soldierCount > 1 }
        guard let from = botCells.randomElement() else { return }
        let targets = cells.filter { cell in
            if let owner = cell.owner {
                return owner.isHuman
            } else {
                return true
            }
        }
        guard let to = targets.min(by: { $0.soldierCount < $1.soldierCount }) else { return }
        if let sendPercent = sendPercent {
            from.sendSoldiers(to: to, sendPercentage: sendPercent)
        }
    }
}

class TerritoryNode: SKNode {
    let id: Int
    let shape: SKSpriteNode
    private let tower: SKSpriteNode
    private let label: SKLabelNode
    weak var owner: Player? {
        didSet { updateAppearance() }
    }
    var soldierCount: Int = 10 {
        didSet { label.text = "\(soldierCount)" }
    }
    private var growthTime: TimeInterval = 0

    init(id: Int, texture: SKTexture, position: CGPoint, owner: Player?) {
        self.id = id
        self.shape = SKSpriteNode(texture: texture)
        // Initialize tower with appropriate icon
        let towerTextureName = owner?.isHuman == true ? "hat" : (owner != nil ? "pistol" : "question")
        self.tower = SKSpriteNode(imageNamed: towerTextureName)
        self.label = SKLabelNode(fontNamed: "Helvetica-Bold")
        self.owner = owner
        super.init()
        self.position = position

        shape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shape.setScale(0.5)
        shape.zPosition = 0
        addChild(shape)

        tower.setScale(0.5)
        tower.zPosition = 2
        addChild(tower)

        label.fontSize = 18
        label.verticalAlignmentMode = .center
        label.zPosition = 3
        addChild(label)

        updateAppearance()
    }

    required init?(coder: NSCoder) { fatalError() }

    func update(deltaTime dt: TimeInterval) {
        guard owner != nil else { return }
        growthTime += dt
        if growthTime >= 1.3 {
            soldierCount += 1
            growthTime = 0
        }
    }

    func setHighlight(_ on: Bool) {
        shape.run(.scale(to: on ? 0.6 : 0.5, duration: 0.1))
    }

    func sendSoldiers(to target: TerritoryNode, sendPercentage: CGFloat) {
        let countToSend = Int(CGFloat(soldierCount) * sendPercentage)
        let sending = max(1, min(soldierCount, countToSend))
        guard sending > 0, let attacker = owner, let scene = scene else { return }
        soldierCount = soldierCount - sending
        // convert tower center to scene coords
        let start = convert(tower.position, to: scene)
        let end = target.convert(target.tower.position, to: scene)
        for i in 0..<sending {
            let s = SoldierNode(color: attacker.color)
            let col = i % 4
            let row = i / 4
            let spacing: CGFloat = 12
            s.position = CGPoint(
                x: start.x + (CGFloat(col) - 1.5)*spacing,
                y: start.y - CGFloat(row)*spacing
            )
            s.zPosition = 5
            scene.addChild(s)
            let delay = Double(i) * 0.02
            s.move(to: end, after: delay) {
                target.receiveSoldier(from: attacker)
            }
        }
    }

    func receiveSoldier(from attacker: Player) {
        if owner === attacker {
            soldierCount += 1
        } else {
            soldierCount -= 1
            if soldierCount < 0 {
                owner = attacker
                soldierCount = abs(soldierCount)
            }
        }
    }

    func contains(point: CGPoint) -> Bool {
        let local = convert(point, from: parent!)
        return shape.contains(local)
    }

    private func updateAppearance() {
        let towerName: String
        if owner?.isHuman == true {
            towerName = "hat"
        } else if owner != nil {
            towerName = "pistol"
        } else {
            towerName = "question"
        }
        tower.texture = SKTexture(imageNamed: towerName)

        let base = owner?.color ?? .lightGray
        shape.color = base
        shape.colorBlendFactor = 1.0
        tower.colorBlendFactor = 0.0

        label.fontColor = .white
        label.text = "\(soldierCount)"
        tower.position = .zero
        label.position = CGPoint(x: 0, y: -tower.size.height/2 - 10)
    }
}

class SoldierNode: SKShapeNode {
    init(color: UIColor) {
        super.init()
        let size: CGFloat = 8
        path = CGPath(ellipseIn: CGRect(x: -size/2, y: -size/2, width: size, height: size), transform: nil)
        fillColor = color
        strokeColor = .black  
                lineWidth = 1.0
        zPosition = 6
    }
    required init?(coder: NSCoder) { fatalError() }

    func move(to point: CGPoint, after delay: TimeInterval, completion: @escaping () -> Void) {
            // Compute speed and duration
            let dx = point.x - position.x
            let dy = point.y - position.y
            let distance = sqrt(dx*dx + dy*dy)
            let speed: CGFloat = 50  // points per second
            let moveDuration = TimeInterval(distance / speed)

            let sequence = SKAction.sequence([
                .wait(forDuration: delay),
                .move(to: point, duration: moveDuration),
                .run(completion),
                .removeFromParent()
            ])
            run(sequence)
        }
}

class Player: Hashable {
    let name: String
    let isHuman: Bool
    let color: UIColor
    init(name: String, isHuman: Bool, color: UIColor) {
        self.name = name; self.isHuman = isHuman; self.color = color
    }
    static func == (l: Player, r: Player) -> Bool { l === r }
    func hash(into hasher: inout Hasher) { hasher.combine(ObjectIdentifier(self)) }
}
