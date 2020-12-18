import Foundation

enum Field {
    case empty
    case product
    case finish
    case step
}

extension Field {
    var symbol: String {
        switch self {
        case .empty:
            return " "
        case .finish:
            return "F"
        case .product:
            return "B"
        case .step:
            return "*"
        }
    }
}

enum Move: Int, CaseIterable {
    case left = 0
    case right
    case up
    case down
}

let rewards: [Field: Double] = [
    .empty: -1.0,
    .finish: 100.0,
    .product: -100.0
]

var map: [[Field]] = [
    [.product, .product, .product, .product, .product, .finish, .product, .product, .product, .product, .product],
    [.product, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .product],
    [.product, .empty, .product, .product, .product, .product, .product, .empty, .product, .empty, .product],
    [.product, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .product, .empty, .product],
    [.product, .product, .product, .empty, .product, .product, .product, .empty, .product, .product, .product],
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
    [.product, .product, .product, .product, .product, .empty, .product, .product, .product, .product, .product],
    [.product, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty ,.product],
    [.product, .product, .product, .empty, .product, .product, .product, .empty, .product, .product, .product],
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
    [.product, .product, .product, .product, .product, .product, .product, .product, .product, .product, .product]
]

var qValues: [[[Double]]] = .init(repeating: .init(repeating: .init(repeating: 0.0, count: 4), count: 11), count: 11)

let emptyFields = Array(map.enumerated().map { rowIndex, row in
    (rowIndex, row.enumerated().map { columIndex, elem in
        (rowIndex, columIndex, elem)
    })}.map { $0.1 }.joined()).filter { $0.2 == .empty }

//print(emptyFields)

func printMap(_ map: [[Field]]) {
    map.enumerated().forEach { (rowIndex, row) in
        if rowIndex == 0 {
            print("     0   1   2   3   4   5   6   7   8   9   X")
            print("   ╔═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╗")
        }
        else {
            print("   ╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢")
        }

        row.enumerated().forEach { (columnIndex, elem) in
            if columnIndex == 0 {
                print("\(rowIndex == 10 ? "X" : "\(rowIndex)")  ╟", terminator: "")
            }
            else {
                print("║", terminator: "")
            }
            print(" \(elem.symbol) ", terminator: "")
        }
        print("║")
    }
    print("   ╚═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╝")
}

printMap(map)

func isTerminalState(_ position: (row: Int, column: Int)) -> Bool {
    let field = map[position.row][position.column]
    return field != .empty
}

func choseRandonEmptyField() -> (Int, Int) {
    let emptyField = emptyFields[Int.random(in: 0..<emptyFields.count)]
    return (emptyField.0, emptyField.1)
}

func chooseRandomMoveDirection() -> Move {
    return Move.allCases[Int.random(in: 0..<4)]
}

func chooseNextMoveDirection(for position: (row: Int, column: Int), with epsilon: Double) -> Move {
    let random: Double = Double(Int.random(in: 0...100)) / 100
    if random < epsilon {
        let maxQ = qValues[position.row][position.column].max()!
        return Move.init(rawValue: qValues[position.row][position.column].firstIndex(of: maxQ)!)!
    }
    else {
        return chooseRandomMoveDirection()
    }
}

func newPosition(from position: (row: Int, column: Int), move: Move) -> (Int, Int) {
    let newPosition: (Int, Int)
    switch move {
    case .down:
        newPosition = (position.row + 1, position.column)
    case .left:
        newPosition = (position.row, position.column - 1)
    case .up:
        newPosition = (position.row - 1, position.column)
    case .right:
        newPosition = (position.row, position.column + 1)
    }

    guard (0...10).contains(newPosition.0) && (0...10).contains(newPosition.1) else {
        return position
    }
    return newPosition
}

func getShortestPath(from position: (row: Int, column: Int)) -> [(Int, Int)] {
    guard !isTerminalState(position) else {
        return []
    }

    var shortestPath: [(Int, Int)] = [position]
    var currentPosition = position
    while !isTerminalState(currentPosition) {
        // get the best move to take
        let move = chooseNextMoveDirection(for: currentPosition, with: 1.0)
        // move to the next location on the path, and add the new location to the list
        currentPosition = newPosition(from: currentPosition, move: move)
        shortestPath.append(currentPosition)
    }

    return shortestPath
}

let epsilon = 0.9
let discountFactor = 0.9
let learningRate = 0.9

for _ in 0..<1000 {
    var currentPosition = choseRandonEmptyField()
    while !isTerminalState(currentPosition) {
        let move = chooseNextMoveDirection(for: currentPosition, with: epsilon)
        let oldPosition = currentPosition
        currentPosition = newPosition(from: currentPosition, move: move)

        let reward = rewards[map[currentPosition.0][currentPosition.1]]!
        let oldQValue = qValues[oldPosition.0][oldPosition.1][move.rawValue]
        let maxQValue = qValues[currentPosition.0][currentPosition.1].max()!
        let diff: Double = reward + (discountFactor * maxQValue) - oldQValue

        let newQValue = oldQValue + (learningRate * diff)
        qValues[oldPosition.0][oldPosition.1][move.rawValue] = newQValue
    }
}

func printResultMap(from initalMap: [[Field]], path: [(Int, Int)]) {
    var resultMap = initalMap
    path.forEach { step in
        resultMap[step.0][step.1] = .step
    }
    printMap(resultMap)
}

printResultMap(from: map, path: getShortestPath(from: (row: 3, column: 9)))
printResultMap(from: map, path: getShortestPath(from: (row: 5, column: 0)))
printResultMap(from: map, path: getShortestPath(from: (row: 9, column: 5)))
printResultMap(from: map, path: getShortestPath(from: (row: 5, column: 2)).reversed())
