//
//  GameViewModel.swift
//  game
//
//  Created by 張凱翔 on 2021/7/5.
//

import SwiftUI
import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Game: ObservableObject {
    @Published var players = [Player(), Player()]
    var currentPlayerIndex = 0
    var locationsCount = 12
    var timer: Timer.TimerPublisher?
    var anyCancellable: AnyCancellable?
    var steps = Int.random(in: 1...6)
  
    
    func playerMove() {
        currentPlayerIndex = 0
        var player = players[currentPlayerIndex]
        player.targetLocation = (player.targetLocation + steps) % locationsCount
        players[currentPlayerIndex] = player
        
        anyCancellable = Timer.publish (every: 0.1, on: .main, in: .common).autoconnect().sink(receiveValue: {[self] _ in
            var player = players[currentPlayerIndex]
            if player.currentLocation != player.targetLocation {
                player.currentLocation += 1
                if player.currentLocation == locationsCount {
                    player.currentLocation = 0
                }
                players[currentPlayerIndex] = player
            } else {
                anyCancellable = nil
            }
        })
    }
}
