import SpriteKit
import UIKit

class MGMazeScene: SKScene {

    private var maze: [[Int]] = []
    private let rows = 15
    private let cols = 15

    private var tileSize: CGSize = .zero
    private var mazeOrigin: CGPoint = .zero

    private var player: SKSpriteNode!
    private var exitNode: SKSpriteNode!
    var isWinHandler: (() -> ())?

    private let wallThicknessFactor: CGFloat = 0.4  

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        maze = generateMaze(rows: rows, cols: cols)
        layoutMazeArea()
        drawMazeBackground() 
        drawMaze()
        setupPlayer()
        setupExit()
        setupSwipeGestures()
    }


    private func layoutMazeArea() {
        let gridRows = maze.count
        let gridCols = maze[0].count
        let maxSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height * 0.5)
        let cellSide = maxSide / CGFloat(gridCols)
        tileSize = CGSize(width: cellSide, height: cellSide)


        let totalWidth = CGFloat(gridCols) * cellSide
        let originX = (UIScreen.main.bounds.width - totalWidth) * 0.40
        let originY = UIScreen.main.bounds.height * 0.15
        mazeOrigin = CGPoint(x: originX, y: originY)
    }


    private func generateMaze(rows: Int, cols: Int) -> [[Int]] {
        let gridRows = rows * 2 + 1
        let gridCols = cols * 2 + 1
        var grid = Array(repeating: Array(repeating: 1, count: gridCols), count: gridRows)
        func carve(r: Int, c: Int) {
            grid[r*2 + 1][c*2 + 1] = 0
            for (dr, dc) in [(0,1),(1,0),(0,-1),(-1,0)].shuffled() {
                let nr = r + dr, nc = c + dc
                if nr >= 0, nr < rows, nc >= 0, nc < cols,
                   grid[nr*2 + 1][nc*2 + 1] == 1 {
                    grid[r*2 + 1 + dr][c*2 + 1 + dc] = 0
                    carve(r: nr, c: nc)
                }
            }
        }
        carve(r: 0, c: 0)
        grid[gridRows - 2][gridCols - 2] = 2 // exit
        return grid
    }


    private func drawMaze() {
        let gridRows = maze.count
        let gridCols = maze[0].count
        let wallSize = CGSize(width: tileSize.width * wallThicknessFactor,
                              height: tileSize.height * wallThicknessFactor)
        for r in 0..<gridRows {
            for c in 0..<gridCols where maze[r][c] == 1 {
                let x = mazeOrigin.x + CGFloat(c) * tileSize.width + tileSize.width/2
                let y = mazeOrigin.y + CGFloat(gridRows - r - 1) * tileSize.height + tileSize.height/2
                let wall = SKSpriteNode(color: .white, size: wallSize)
                wall.position = CGPoint(x: x, y: y)
                addChild(wall)
            }
        }
    }

    private func drawMazeBackground() {
        let rows = maze.count
        let cols = maze[0].count

        let width = CGFloat(cols) * tileSize.width
        let height = CGFloat(rows) * tileSize.height

        let bgSize = CGSize(width: width, height: height)
        let bgNode = SKSpriteNode(color: .appBrown, size: bgSize)

        bgNode.position = CGPoint(
            x: mazeOrigin.x + width / 2,
            y: mazeOrigin.y + height / 2
        )
        bgNode.zPosition = -1
        addChild(bgNode)
    }

    private func setupPlayer() {

        let startRow = 1, startCol = 1
        let pos = positionForCell(row: startRow, col: startCol)
        let texture = SKTexture(imageNamed: "redSquareMG")
        player = SKSpriteNode(texture: texture, size: tileSize)
        player.position = pos
        addChild(player)
    }


    private func setupExit() {
        let gridRows = maze.count
        let gridCols = maze[0].count
        for r in 0..<gridRows {
            for c in 0..<gridCols where maze[r][c] == 2 {
                let pos = positionForCell(row: r, col: c)
                let texture = SKTexture(imageNamed: "blueSquareMG")
                exitNode = SKSpriteNode(texture: texture, size: tileSize)
                exitNode.position = pos
                addChild(exitNode)
                return
            }
        }
    }

    private func positionForCell(row: Int, col: Int) -> CGPoint {
        let x = mazeOrigin.x + CGFloat(col) * tileSize.width + tileSize.width/2
        let y = mazeOrigin.y + CGFloat(maze.count - row - 1) * tileSize.height + tileSize.height/2
        return CGPoint(x: x, y: y)
    }


    private func setupSwipeGestures() {
        guard let view = self.view else { return }
        for dir in [UISwipeGestureRecognizer.Direction.up,
                    .down, .left, .right] {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipe.direction = dir
            view.addGestureRecognizer(swipe)
        }
    }
    
    private func moveBy(dx: CGFloat, dy: CGFloat) {
            let newPos = CGPoint(x: player.position.x + dx, y: player.position.y + dy)
            let col = Int((newPos.x - mazeOrigin.x) / tileSize.width)
            let rowIndex = Int((newPos.y - mazeOrigin.y) / tileSize.height)
            let row = maze.count - rowIndex - 1
            guard row >= 0, row < maze.count, col >= 0, col < maze[0].count, maze[row][col] != 1 else {
                return
            }
            let move = SKAction.move(to: newPos, duration: 0.1)
            player.run(move) {
                if self.maze[row][col] == 2 {
                    self.isWinHandler?()
                    
                    
                }
            }
        }
    
    
    
    func moveUp() {
        moveBy(dx: 0, dy: tileSize.height)
    }
    
    func moveDown() {
        moveBy(dx: 0, dy: -tileSize.height)
    }
    
    func moveLeft() {
        moveBy(dx: -tileSize.width, dy: 0)
    }
    
    func moveRight() {
        moveBy(dx: tileSize.width, dy: 0)
    }
    
    func restartGame() {

        removeAllChildren()

        maze = generateMaze(rows: rows, cols: cols)
        layoutMazeArea()
        drawMazeBackground() 
        drawMaze()
        setupPlayer()
        setupExit()
        setupSwipeGestures()
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up: moveUp()
        case .down: moveDown()
        case .left: moveLeft()
        case .right: moveRight()
        default: break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        for node in nodes(at: location) {
            guard let name = node.name else { continue }
            switch name {
            case "btn_up": moveUp()
            case "btn_down": moveDown()
            case "btn_left": moveLeft()
            case "btn_right": moveRight()
            default: break
            }
        }
    }
}

