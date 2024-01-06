//
//  GameView.swift
//  TicTacToe
//
//  Created by wizz on 1/1/24.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            if [game.player1.isCurrent, game.player2.isCurrent].allSatisfy({ $0 == false }) {
                Text("Select a player to start")
            }
            HStack{
                Button(game.player1.name){
                    game.player1.isCurrent = true
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player1.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }.buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                
                
                Button(game.player2.name){
                    game.player2.isCurrent = true
                    if game.gameType == .bot {
                        Task { await game.deviceMove() }
                    }
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player2.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }.buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
                
            }
            .disabled(game.gameStarted)
            
            VStack{
                HStack{
                    ForEach(0...2, id: \.self){ index in
                            SquareView(index: index)
                    }
                }
                
                HStack{
                    ForEach(3...5, id: \.self){ index in
                        SquareView(index: index)
                    }
                }
                HStack{
                    ForEach(6...8, id: \.self){ index in
                        SquareView(index: index)
                    }
                }
            }
            .overlay{
                if game.isThinking {
                    VStack {
                        Text("Thinking... ")
                            .foregroundStyle(Color(.systemBackground))
                            .background(Rectangle().fill(Color.primary))
                        ProgressView()
                    }
                }
            }
            .disabled(game.boardDisabled || game.gameType == .peer && connectionManager.myPeerId.displayName != game.currentPlayer.name)
            
            VStack{
                if game.gameOver {
                    Text("Game Over")
                    if game.possibleMoves.isEmpty {
                        Text("It's a Draw! 😐")
                    }else{
                        Text("\(game.currentPlayer.name) wins! 👑")
                    }
                    
                    Button("New Game") {
                        game.reset()
                        if game.gameType == .peer {
                            let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                            connectionManager.send(gameMove: gameMove)
                        }
                    }.buttonStyle(.borderedProminent)
                }
            }
            .font(.largeTitle)
            Spacer()
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End Game"){
                    dismiss()
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .end, playerName: nil, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }.buttonStyle(.bordered)
            }
        }
        .navigationTitle("Xs And Os")
        .onAppear{
            game.reset()
            if game.gameType == .peer {
                connectionManager.setup(game: game)
            }
        }
        .inNavigationStack()
    }
}

#Preview {
    GameView()
        .environmentObject(GameService())
        .environmentObject(MPConnectionManager(yourName: "Test"))
}


struct PlayerButtonStyle: ButtonStyle {
    let isCurrent: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10).fill(isCurrent ? Color.green : Color.gray))
            .foregroundStyle(.white)
    }
}
