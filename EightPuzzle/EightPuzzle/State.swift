class State {
    let field: [[Int]]
    var prev: State?
    var d = 0
    
    var aStarValue = 0
    var visited = false

    init(field: [[Int]]) {
        self.field = field
    }

    static let end = State(
        field: [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8]
        ]
    )
}

extension State: Hashable {
    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.field == rhs.field
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(field)
    }
}


func generateStartState(from state: State) -> (state: State, moves: Int) {
    var field = state.field

    let moves = Int.random(in: 10...100)

    for _ in 0..<moves {
        makeMove(in: &field)
    }

    return (State(field: field), moves)
}
