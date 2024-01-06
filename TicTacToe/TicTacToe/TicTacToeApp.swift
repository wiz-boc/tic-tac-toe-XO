//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by wizz on 1/1/24.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    @AppStorage("yourName") var yourName = ""
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                YourNameView()
            }else{
                StartView(yourName: yourName)
                    .environmentObject(game)
            }
        }
    }
}
