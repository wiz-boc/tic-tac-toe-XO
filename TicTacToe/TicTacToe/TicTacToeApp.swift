//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by wizz on 1/1/24.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(game)
        }
    }
}
