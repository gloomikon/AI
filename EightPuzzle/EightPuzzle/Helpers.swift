import Foundation

extension Array where Element : Collection,
    Element.Iterator.Element : Equatable, Element.Index == Int {

    func indices(of x: Element.Iterator.Element) -> Position? {
        for (i, row) in self.enumerated() {
            if let j = row.firstIndex(of: x) {
                return .init(x: j, y: i)
            }
        }
        return nil
    }
}

struct Position: Hashable {
    let x: Int
    let y: Int
}

enum Move: Int {
    case left = 0
    case right
    case top
    case bottom
}

let movesForPosition: [Position: [Move]] = [
    .init(x: 0, y: 0): [.right, .bottom],
    .init(x: 1, y: 0): [.left, .right, .bottom],
    .init(x: 2, y: 0): [.left, .bottom],
    .init(x: 0, y: 1): [.top, .right, .bottom],
    .init(x: 1, y: 1): [.top, .left, .right, .bottom],
    .init(x: 2, y: 1): [.top, .left, .bottom],
    .init(x: 0, y: 2): [.top, .right],
    .init(x: 1, y: 2): [.top, .left, .right],
    .init(x: 2, y: 2): [.top, .left],
]


func makeMove(in field: inout [[Int]]) {
    guard let zeroPosition = field.indices(of: 0) else {
        return
    }

    let possibleMoves = movesForPosition[zeroPosition]!
    let move = possibleMoves[Int.random(in: 0..<possibleMoves.count)]
    
    switch move {
    case .left:
        field[zeroPosition.y][zeroPosition.x] = field[zeroPosition.y][zeroPosition.x - 1]
        field[zeroPosition.y][zeroPosition.x - 1] = 0
    case .right:
        field[zeroPosition.y][zeroPosition.x] = field[zeroPosition.y][zeroPosition.x + 1]
        field[zeroPosition.y][zeroPosition.x + 1] = 0
    case .bottom:
        field[zeroPosition.y][zeroPosition.x] = field[zeroPosition.y + 1][zeroPosition.x]
        field[zeroPosition.y + 1][zeroPosition.x] = 0
    case .top:
        field[zeroPosition.y][zeroPosition.x] = field[zeroPosition.y - 1][zeroPosition.x]
        field[zeroPosition.y - 1][zeroPosition.x] = 0
    }
}

