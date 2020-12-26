//
//  ViewController.swift
//  TicTacToe
//
//  Created by Nikolay Zhurba on 26.12.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var cells: [UIButton]!
    let minimax = Minimax()
    private var gameIsStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = "Choose an option"
    }

    @IBAction func goFirstButtonPressed(_ sender: Any) {
        gameIsStarted = true
        descriptionLabel.text = "Choose the cell"
    }

    @IBAction func goSecondButtonPressed(_ sender: Any) {
        gameIsStarted = true
        descriptionLabel.text = "Choose the cell"
        minimax.aiTurn()
        updateBoard()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard gameIsStarted else {
            return
        }

        let tag = sender.tag
        let x = tag % 3
        let y = tag / 3

        let position = Position(x: x, y: y)
        minimax.humanTurn(position: position)

        updateBoard()
        minimax.aiTurn()
        updateBoard()

        if minimax.gameOver() {
            switch minimax.gameResult() {
            case .botWin:
                descriptionLabel.text = "AI has won"
            case .humanWin:
                descriptionLabel.text = "You have won"
            case .draw:
                descriptionLabel.text = "Draw"
            }
        }
    }

    @IBAction func restartButtonPressed(_ sender: Any) {
        minimax.board = initialBoard
        gameIsStarted = false
        updateBoard()
        cells.forEach {
            $0.isUserInteractionEnabled = true
        }
        descriptionLabel.text = "Choose an option"
    }
}

private extension ViewController {
    func updateBoard() {
        let board = minimax.board
        for (y, row) in board.enumerated() {
            for (x, cell) in row.enumerated() {
                let buttomCell = cells.first(where: { $0.tag == y * 3 + x})!
                let title: String
                if cell == 1 {
                    title = "X"
                    buttomCell.isUserInteractionEnabled = false
                }
                else if cell == -1 {
                    title = "O"
                    buttomCell.isUserInteractionEnabled = false
                }
                else {
                    title = ""
                }
                buttomCell.setTitle(title, for: .normal)
            }
        }
    }
}

