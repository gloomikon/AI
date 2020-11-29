import Foundation

// MARK: - Common helper

func makePossibleStates(for state: State) -> [State] {
    let field = state.field
    guard let zeroPosition = field.indices(of: 0) else {
        return []
    }

    let possibleMoves = movesForPosition[zeroPosition]!
    let states = possibleMoves.map { move -> State in
        let newState: State
        var newField = field

        switch move {
        case .left:
            newField[zeroPosition.y][zeroPosition.x] = newField[zeroPosition.y][zeroPosition.x - 1]
            newField[zeroPosition.y][zeroPosition.x - 1] = 0
        case .right:
            newField[zeroPosition.y][zeroPosition.x] = newField[zeroPosition.y][zeroPosition.x + 1]
            newField[zeroPosition.y][zeroPosition.x + 1] = 0
        case .bottom:
            newField[zeroPosition.y][zeroPosition.x] = newField[zeroPosition.y + 1][zeroPosition.x]
            newField[zeroPosition.y + 1][zeroPosition.x] = 0
        case .top:
            newField[zeroPosition.y][zeroPosition.x] = newField[zeroPosition.y - 1][zeroPosition.x]
            newField[zeroPosition.y - 1][zeroPosition.x] = 0
        }

        newState = .init(field: newField)
        newState.d = state.d + 1 // for LDFS
        newState.aStarValue = state.correctNumbersCount + newState.correctNumbersCount // for A*
        newState.prev = state

        return newState
    }

    return states
}

// MARK: - Non informative search (LDFS)

func ldfs(for state: State, maxDepth: Int) {
    // For analytics
    let start = CFAbsoluteTimeGetCurrent()
    var iterations: Double = 0
    var queueCapacity: Double = 0

    var queue = [state]
    var visited: [State: Bool] = [state: true]


    while !queue.isEmpty {
        iterations += 1
        queueCapacity += Double(queue.count)

        let currentState = queue.first!
        guard currentState != State.end else {
            State.end.prev = currentState.prev
            State.end.d = currentState.d
            break
        }

        let newStates = makePossibleStates(for: currentState).filter { visited[$0] != true && $0.d <= maxDepth }
        queue.insert(contentsOf: newStates, at: 1)
        newStates.forEach {
            visited[$0] = true
        }

        queue.removeFirst()
    }
    
    // Analytics
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Time: \(diff) seconds")
    print("Moves done: \(State.end.d)")
    print("All states: \(visited.count)")
    print("Queue medium capacity: \(queueCapacity / iterations)")
}

// MARK: - Informative search helper (aka heuristic function)


extension State {
    var correctNumbersCount: Int {
        var count = 0

        for x in 0..<3 {
            for y in 0..<3 {
                let number = field[y][x]
                if number / 3 == y && number % 3 == x {
                    count += 1
                }
            }
        }

        return count
    }
}

// MARK: - Informative search (A*)

func aStar(for state: State) {
    // For analytics
    let start = CFAbsoluteTimeGetCurrent()
    var iterations: Double = 0
    var queueCapacity: Double = 0

    var queue = [state]
    var visited: [State: Bool] = [state: true]

    var currentState = queue.first!
    while currentState != State.end {
        iterations += 1
        queueCapacity += Double(queue.count)

        let newStates = makePossibleStates(for: currentState).filter { visited[$0] != true }
        queue.append(contentsOf: newStates.filter { visited[$0] != true })
        newStates.forEach {
            visited[$0] = true
        }

        currentState = queue.filter{ $0.visited == false }.max { a,b in a.aStarValue < b.aStarValue }!
        currentState.visited = true

        if currentState == State.end {
            State.end.prev = currentState.prev
            State.end.d = currentState.d
        }
    }

    // Analytics
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Time: \(diff) seconds")
    print("Moves done: \(State.end.d)")
    print("All states: \(visited.count)")
    print("Queue medium capacity: \(queueCapacity / iterations)")
}
