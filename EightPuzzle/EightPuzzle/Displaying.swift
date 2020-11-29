import Foundation

func displayField(_ field: [[Int]]) {
    func displayableNumber(_ n: Int) -> String {
        return n == 0 ? " " : "\(n)"
    }

    let fieldTxt =
    """
    ╔═══╤═══╤═══╗
    ╟ \(displayableNumber(field[0][0])) ║ \(displayableNumber(field[0][1])) ║ \(displayableNumber(field[0][2])) ║
    ╟───┼───┼───╢
    ╟ \(displayableNumber(field[1][0])) ║ \(displayableNumber(field[1][1])) ║ \(displayableNumber(field[1][2])) ║
    ╟───┼───┼───╢
    ╟ \(displayableNumber(field[2][0])) ║ \(displayableNumber(field[2][1])) ║ \(displayableNumber(field[2][2])) ║
    ╚═══╧═══╧═══╝
    """

    print(fieldTxt)
}

func displayState(_ state: State) {
    func displayableNumber(_ n: Int) -> String {
        return n == 0 ? " " : "\(n)"
    }

    let field = state.field

    let fieldTxt =
    """
    ╔═══╤═══╤═══╗
    ╟ \(displayableNumber(field[0][0])) ║ \(displayableNumber(field[0][1])) ║ \(displayableNumber(field[0][2])) ║
    ╟───┼───┼───╢
    ╟ \(displayableNumber(field[1][0])) ║ \(displayableNumber(field[1][1])) ║ \(displayableNumber(field[1][2])) ║   d = \(state.d)
    ╟───┼───┼───╢
    ╟ \(displayableNumber(field[2][0])) ║ \(displayableNumber(field[2][1])) ║ \(displayableNumber(field[2][2])) ║   a* = \(state.aStarValue)
    ╚═══╧═══╧═══╝
    """

    print(fieldTxt)
}

func displayResult() {
    var fields: [[[Int]]] = []

    var state: State? = State.end
    while state != nil {
        fields.append(state!.field)
        state = state!.prev
    }

    fields.reversed().forEach {
        displayField($0)
    }
}
