//
//  UserData.swift
//  game
//
//  Created by 張凱翔 on 2021/7/1.
//

import FirebaseFirestoreSwift
import Combine

struct UserData: Codable, Identifiable{
    @DocumentID var id: String?
    var email: String
    var password: String
    var name: String
    var gender: String
    var hair: String
    var body: String
    var shoes: String
    var imgURL: String
}

class userData: ObservableObject{
    @Published var user = UserData( email: "", password: "", name: "", gender: "女", hair: "金髮", body: "女衣1", shoes: "女鞋1", imgURL: "")
}
