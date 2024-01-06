//
//  ContentView.swift
//  TicTacToe
//
//  Created by wizz on 1/1/24.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var game: GameService
    
    @State private var gameType: GameType = .undetermined
    @AppStorage("yourName") private var yourName = ""
    @State private var opponentName = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    @State private var changeName = false
    @State private var newName = ""
    
    init(yourName: String){
        self.yourName = yourName
    }
    
    var body: some View {
            VStack {
                Picker("Select Game", selection: $gameType){
                    Text("Select Game Type").tag(GameType.undetermined)
                    Text("Two Sharing Device").tag(GameType.single)
                    Text("Challenge your device").tag(GameType.bot)
                    Text("Challenge you friend").tag(GameType.peer)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
                
                Text(gameType.description)
                    .padding()
                VStack{
                    switch gameType {
                        case .single:
                            VStack{
                               // TextField("Your Name", text: $yourName)
                                TextField("Opponent Name", text: $opponentName)
                            }
                        case .bot:
                            //TextField("Your Name", text: $yourName)
                            EmptyView()
                        case .peer, .undetermined:
                            EmptyView()
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .focused($focus)
                .frame(width: 350)
                
                if gameType != .peer {
                    Button("Start Game"){
                        game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                        focus = false
                        startGame.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        gameType == .undetermined ||
                        gameType == .single && opponentName.isEmpty
                    )
                    Image("LaunchScreen")
                    Text("Your name is \(yourName)")
                    Button("Change my name"){
                        changeName.toggle()
                    }
                    .buttonStyle(.bordered)
                }
                Spacer()
                
            }
            .padding()
            .navigationTitle("Xs And Os")
            .onAppear{
                game.reset()
            }
            .fullScreenCover(isPresented: $startGame) {
                GameView()
            }
            .alert("Change Name", isPresented: $changeName, actions: {
                TextField("New name", text: $newName)
                Button("OK", role: .destructive){
                    yourName = newName
                    exit(-1)
                }
                
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("Tapping Ok to save new name")
            })
            .inNavigationStack()
        }
}

#Preview {
    StartView(yourName: "wizzz")
        .environmentObject(GameService())
}
