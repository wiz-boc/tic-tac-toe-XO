//
//  SquareView.swift
//  TicTacToe
//
//  Created by wizz on 1/1/24.
//

import SwiftUI

struct SquareView: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    let index: Int
    var body: some View {
        Button{
            if !game.isThinking {
                game.makeMove(at: index)
            }
            if game.gameType == .peer {
                let gameMove = MPGameMove(action: .move, playerName: connectionManager.myPeerId.displayName, index: index)
                connectionManager.send(gameMove: gameMove)
            }
        } label: {
            game.gameBoard[index].image
                .resizable()
                .frame(width: 100, height: 100)
        }
        .disabled(game.gameBoard[index].player != nil)
        .foregroundStyle(.primary)
    }
}

#Preview {
    SquareView( index: 1)
        .environmentObject(GameService())
        .environmentObject(MPConnectionManager(yourName: "Test"))
}
