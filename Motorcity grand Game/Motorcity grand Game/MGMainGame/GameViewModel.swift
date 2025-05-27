class GameViewModel: ObservableObject {
    @Published var cells: [CellData]

    init() {
        // Инициализация из игрового мира
        let positions = [
            CGPoint(x: 150, y: 300), CGPoint(x: 300, y: 500),
            CGPoint(x: 500, y: 300), CGPoint(x: 300, y: 100)
        ]
        cells = positions.enumerated().map { idx, pos in
            CellData(id: idx,
                     position: pos,
                     ownerColor: idx < 2 ? (idx == 0 ? .red : .blue) : .gray,
                     soldierCount: idx < 2 ? 12 : nil)
        }
    }
}