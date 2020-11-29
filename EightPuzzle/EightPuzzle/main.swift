import Foundation

var (startState, moves) = generateStartState(from: State.end)

print("Starting field:")
displayField(startState.field)
print("Moves was done to generate: \(moves)")

print("LDFS")
ldfs(for: startState, maxDepth: moves)
//displayResult()

State.end.prev = nil
State.end.d = 0
State.end.aStarValue = 0
State.end.visited = false

print("A*")
aStar(for: startState)
//displayResult()
