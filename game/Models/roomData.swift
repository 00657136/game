//
//  roomData.swift
//  game
//
//  Created by 張凱翔 on 2021/7/4.
//

import FirebaseFirestoreSwift
import Combine

struct roomData: Codable,Identifiable {
    @DocumentID var id: String?
    var inviteNumber: String
    var playerEmail: String
    var playerName: String
    var playerImg: String
    var isHost: Bool
    var isready:Bool
    var playerIndex:Int
}
struct roomCheck:  Codable,Identifiable{
    @DocumentID var id: String?
    var roomNumber: String
    var isGameStart: Bool
    var money:Int
}
