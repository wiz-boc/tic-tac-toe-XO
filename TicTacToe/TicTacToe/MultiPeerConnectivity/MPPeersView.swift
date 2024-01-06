//
//  MPPeersView.swift
//  TicTacToe
//
//  Created by wizz on 1/5/24.
//

import SwiftUI

struct MPPeersView: View {
    
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    var body: some View {
        VStack{
            Text("Available Players")
            List(connectionManager.availablePeers, id: \.self) { peer in
                HStack{
                    Text(peer.displayName)
                    Spacer()
                    Button("Select"){
                        game.gameType = .peer
                        connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                        game.player1.name = connectionManager.myPeerId.displayName
                        game.player2.name = peer.displayName
                    }
                    .buttonStyle(.borderedProminent)
                }
                .alert("Received Invitation from \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receivedInvite) {
                    Button("Accept"){
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(true, connectionManager.session)
                            game.player1.name = connectionManager.receivedInviteFrom?.displayName ?? "Unknown"
                            game.player2.name = connectionManager.myPeerId.displayName
                            game.gameType = .peer
                        }
                    }
                    Button("Reject"){
                        if let invitationHandler = connectionManager.invitationHandler {
                            invitationHandler(false, nil)
                        }
                    }
                }
            }
        }
        .onAppear{
            connectionManager.isAvailableToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear{
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
            connectionManager.isAvailableToPlay = false
        }
        .onChange(of: connectionManager.paired) { newValue in
            startGame = newValue
        }
    }
}

#Preview {
    MPPeersView(startGame: .constant(false))
        .environmentObject(GameService())
        .environmentObject(MPConnectionManager(yourName: "Test"))
}
