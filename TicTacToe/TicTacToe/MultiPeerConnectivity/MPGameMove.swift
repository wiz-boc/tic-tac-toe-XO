//
//  MPGameMove.swift
//  TicTacToe
//
//  Created by wizz on 1/5/24.
//

import Foundation


struct MPGameMove: Codable {
    enum Action: Int, Codable { case start, move, reset, end }
    
    let action: Action
    let playerName: String?
    let index: Int?
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
