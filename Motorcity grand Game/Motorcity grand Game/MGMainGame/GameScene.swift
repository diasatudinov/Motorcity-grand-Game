import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var cells: [CellNode] = []
    var players: [Player] = []
    var selectedCell: CellNode?

    override func didMove(to view: SKView) {
        backgroundColor = .white
        setupPlayers()
        setupMap()
    }

    func setupPlayers() {
        let human = Player(name: "Player", isHuman: true, color: .blue)
        let bot = Player(name: "Bot", isHuman: false, color: .red)
        players = [human, bot]
    }

    func setupMap() {
        let positions = [
            CGPoint(x: 150, y: 300),
            CGPoint(x: 300, y: 500),
            CGPoint(x: 500, y: 300),
            CGPoint(x: 300, y: 100)
        ]

        for (i, pos) in positions.enumerated() {
            let owner = i == 0 ? players[0] : (i == 1 ? players[1] : nil)
            let cell = CellNode(position: pos, owner: owner)
            addChild(cell)
            cells.append(cell)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let tappedCell = atPoint(location) as? CellNode {
            if selectedCell == nil {
                if tappedCell.owner?.isHuman == true {
                    selectedCell = tappedCell
                    tappedCell.select()
                }
            } else {
                if tappedCell != selectedCell {
                    selectedCell?.sendSoldiers(to: tappedCell)
                    selectedCell?.deselect()
                    selectedCell = nil
                }
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        for cell in cells {
            cell.update(currentTime: currentTime)
        }
    }
}

class CellNode: SKShapeNode {
    var owner: Player? {
        didSet {
            fillColor = owner?.color ?? .gray
        }
    }
    var soldierCount = 10 {
        didSet {
            label.text = "\(soldierCount)"
        }
    }
    private var lastGrowthTime: TimeInterval = 0
    private let label = SKLabelNode(fontNamed: "Helvetica")

    init(position: CGPoint, owner: Player?) {
        super.init()
        self.position = position
        self.owner = owner

        path = CGPath(ellipseIn: CGRect(x: -30, y: -30, width: 60, height: 60), transform: nil)
        fillColor = owner?.color ?? .gray
        strokeColor = .black
        lineWidth = 2
        name = "cell"

        label.fontSize = 20
        label.position = CGPoint(x: 0, y: -10)
        label.fontColor = .black
        label.zPosition = 1
        label.text = "\(soldierCount)"
        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func update(currentTime: TimeInterval) {
        guard let _ = owner else { return }
        if currentTime - lastGrowthTime >= 1.0 {
            soldierCount += 1
            lastGrowthTime = currentTime
        }
    }

    func select() {
        run(SKAction.scale(to: 1.2, duration: 0.1))
    }

    func deselect() {
        run(SKAction.scale(to: 1.0, duration: 0.1))
    }

    func sendSoldiers(to target: CellNode) {
        let amountToSend = soldierCount / 2
        guard amountToSend > 0 else { return }

        soldierCount -= amountToSend

        for i in 0..<amountToSend {
            let delay = Double(i) * 0.05
            let soldier = SoldierNode(from: self, to: target, owner: self.owner)
            scene?.addChild(soldier)
            soldier.start(after: delay)
        }
    }
}

class SoldierNode: SKShapeNode {
    let target: CellNode
    let owner: Player?

    init(from: CellNode, to: CellNode, owner: Player?) {
        self.target = to
        self.owner = owner
        super.init()
        path = CGPath(ellipseIn: CGRect(x: -5, y: -5, width: 10, height: 10), transform: nil)
        fillColor = owner?.color ?? .black
        position = from.position
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func start(after delay: TimeInterval) {
        let move = SKAction.move(to: target.position, duration: 1.0)
        let wait = SKAction.wait(forDuration: delay)
        let finish = SKAction.run { [weak self] in self?.arrive() }
        run(SKAction.sequence([wait, move, finish, .removeFromParent()]))
    }

    func arrive() {
        if target.owner == owner {
            target.soldierCount += 1
        } else {
            target.soldierCount -= 1
            if target.soldierCount < 0 {
                target.owner = owner
                target.soldierCount = abs(target.soldierCount)
            }
        }
    }
}

class Player {
    let name: String
    let isHuman: Bool
    let color: UIColor

    init(name: String, isHuman: Bool, color: UIColor) {
        self.name = name
        self.isHuman = isHuman
        self.color = color
    }
}