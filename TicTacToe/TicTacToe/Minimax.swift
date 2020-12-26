import Foundation

enum Player: Int {
    case human = -1
    case bot = 1
}

enum Result {
    case humanWin
    case botWin
    case draw
}

struct Position: Equatable {
    let x: Int
    let y: Int
}

let initialBoard: [[Int]] = .init(repeating: .init(repeating: 0, count: 3), count: 3)

class Minimax {
    var board = initialBoard

    func gameOver() -> Bool {
        return gameOver(state: board) || !hasEmptyCells()
    }

    func gameResult() -> Result {
        if wins(state: board, player: .human) {
            return .humanWin
        }
        else if wins(state: board, player: .bot) {
            return .botWin
        }
        return .draw
    }

    func hasEmptyCells() -> Bool {
        return emptyCells(for: board).count > 0
    }

    func aiTurn() {
        let depth = emptyCells(for: board).count

        if depth == 0 || gameOver(state: board) {
            return
        }

        let position: Position

        if depth == 9 {
            position = Position(x: 1, y: 1)
        }
        else {
            let move = minimax(state: &board, depth: depth, player: .bot)
            position = Position(x: move.1, y: move.0)
        }
        
        makeMove(position: position, player: .bot)
    }

    func humanTurn(position: Position) {
        makeMove(position: position, player: .human)
    }

    private func wins(state: [[Int]], player: Player) -> Bool {
        let possibleWinningStates = [
            [state[0][0], state[0][1], state[0][2]],
            [state[1][0], state[1][1], state[1][2]],
            [state[2][0], state[2][1], state[2][2]],
            [state[0][0], state[1][0], state[2][0]],
            [state[0][1], state[1][1], state[2][1]],
            [state[0][2], state[1][2], state[2][2]],
            [state[0][0], state[1][1], state[2][2]],
            [state[2][0], state[1][1], state[0][2]],
        ]

        let playerWinningState: [Int] = .init(repeating: player.rawValue, count: 3)

        return possibleWinningStates.contains(playerWinningState)
    }

    private func evaluate(state: [[Int]]) -> Int {
        if wins(state: state, player: .bot) {
            return 1
        }
        if wins(state: state, player: .human) {
            return -1
        }
        return 0
    }

    func gameOver(state: [[Int]]) -> Bool {
        return wins(state: state, player: .human) || wins(state: state, player: .bot)
    }

    private func emptyCells(for state: [[Int]]) -> [Position] {
        var cells: [Position] = []

        for (y, row) in state.enumerated() {
            for (x, cell) in row.enumerated() {
                if cell == 0 {
                    cells.append(.init(x: x, y: y))
                }
            }
        }

        return cells
    }

    private func moveIsValid(position: Position) -> Bool {
        return emptyCells(for: board).contains(position)
    }

    private func makeMove(position: Position, player: Player) {
        if moveIsValid(position: position) {
            board[position.y][position.x] = player.rawValue
        }
    }

    private func minimax(state: inout [[Int]], depth: Int, player: Player) -> (Int, Int, Int) {
        var best: (Int, Int, Int)

        if player == .bot {
            best = (-1, -1, Int.min)
        }
        else {
            best = (-1, -1, Int.max)
        }

        if depth == 0 || gameOver(state: state) {
            let score = evaluate(state: state)
            return (-1, -1, score)
        }

        for cell in emptyCells(for: state) {
            state[cell.y][cell.x] = player.rawValue
            var score = minimax(state: &state, depth: depth - 1, player: player == .bot ? .human : .bot)
            state[cell.y][cell.x] = 0
            score.0 = cell.y
            score.1 = cell.x

            if player == .bot {
                if score.2 > best.2 {
                    best = score
                }
            }
            else {
                if score.2 < best.2 {
                    best = score
                }
            }
        }

        return best
    }
}


