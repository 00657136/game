//
//  RoomViewModel.swift
//  game
//
//  Created by 張凱翔 on 2021/7/4.
//
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FirebaseDataOfRoom: ObservableObject {
    
    @Published var player = [roomData]()
    @Published var playerself = roomData(inviteNumber: "", playerEmail: "", playerName: "", playerImg: "", isHost: true, isready: false, playerIndex: 0)
 
    func roomDateOrder(){
        player.sort {
            return $0.playerIndex < $1.playerIndex
        }
    }
    
    func checkRoomsChange(roomID: String , completion:  @escaping (Result<String,Error>)-> Void ) {
        let db = Firestore.firestore()
        db.collection("rooms").document(roomID).collection("playerData").addSnapshotListener { snapshot, error in
        guard let snapshot = snapshot else { completion(.failure("error" as! Error)) ; return }
            snapshot.documentChanges.forEach { documentChange in
                switch documentChange.type {
                case .added:
                    print("added")
                    print(roomID)
                    guard let player = try? documentChange.document.data(as: roomData.self) else { break }
                    self.player.append(player)
                    self.roomDateOrder()
                    completion(.success("added"))
                    print(player)
                case .modified:
                    print("modified")
                    guard let player = try? documentChange.document.data(as: roomData.self) else { break }
                    guard let index = self.player.firstIndex(where: {
                        $0.id == player.id
                    }) else { return }
                    self.player[index] = player
                    completion(.success("modified"))
                case .removed:
                    print("removed")
                    guard let player = try? documentChange.document.data(as: roomData.self) else { break }
                    guard let index = self.player.firstIndex(where: {
                        $0.id == player.id
                    }) else { return }
                    self.player.remove(at: index)
                    
                    completion(.success("removed"))
                    if index == self.playerself.playerIndex{
                        
                    }
                }
            }
        }
    }
    func checkGameStart(roomID:String,completion: @escaping (Result<roomCheck,Error>)->Void){
        let db = Firestore.firestore()
        db.collection("roomsCheck").document(roomID).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("偵測失敗")
                return
            }
            guard let isGameStart = try? snapshot.data(as: roomCheck.self) else {
                print("偵測失敗")
                return
            }
            completion(.success(isGameStart))
        }
        
    }
    func changeIsReady(roomID:String, email:String) {
        let db = Firestore.firestore()
        let docureference = db.collection("rooms").document(roomID).collection("playerData").document(email)
        docureference.getDocument{snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,var playerself = try?snapshot.data(as: roomData.self)else
            {
                if let error = error{
                    print("錯誤訊息：",error)
                }
                
                return
            }
            playerself.isready = self.playerself.isready
            do{
                try docureference.setData(from: playerself)
            }catch{
                print(error)
            }
        }
    }
    func changeGameToStart(roomID:String){
        let db = Firestore.firestore()
        let docureference = db.collection("roomCheck").document(roomID)
        docureference.getDocument { snapshot, error in
            guard let snapshot = snapshot,snapshot.exists,var roomcheck = try?snapshot.data(as: roomCheck.self)else
            {
                if let error = error{
                    print(error)
                }
                return
            }
            roomcheck.isGameStart = true
            do{
                try docureference.setData(from: roomcheck)
            }catch{
                print(error)
            }
        }
    }
    func deleteplayer(roomID:String, email:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("rooms").document(roomID).collection("playerData").document(email)
        documentReference.delete()
    }
    
    func deleteroom(roomID:String){
        let db = Firestore.firestore()
        let documentReference1 = db.collection("rooms").document(roomID)
        let documentReference2 = db.collection("roomCheck").document(roomID)
        documentReference1.delete()
        documentReference2.delete()
    }
    
    
}


func createRoom(roomData:roomData ,inviteNumber:String, email: String) {
    let db = Firestore.firestore()
    do {
        try db.collection("rooms").document(inviteNumber).collection("playerData").document(email).setData(from: roomData)
    } catch {
        print(error)
    }
}

func createRoomCheck(roomCheck:roomCheck , inviteNumber:String){
    let db = Firestore.firestore()
    do{
        try db.collection("roomCheck").document(inviteNumber).setData(from: roomCheck)
    } catch {
        print(error)
    }
}

func checkRoomexist(roomID:String, completion: @escaping(Result<Bool,Error>) -> Void) {
    if roomID.isEmpty{
        completion(.success(false))
    }else{
    let db = Firestore.firestore()
        db.collection("roomCheck").whereField("roomNumber", isEqualTo: roomID).getDocuments{querySnapshot, error in
            print(roomID)
            if let querySnapshot = querySnapshot {
                if !querySnapshot.isEmpty{
                    print("進入房間")
                    completion(.success(true))
                }else{
                    print("房間不存在")
                    completion(.success(false))
                }
            }else{
                if let error = error{
                    completion(.failure(error))
                }
            }
        }
    }
}

func checkRoomPlayerNumber(roomID:String, completion: @escaping(Result<Int,Error>) -> Void){
    let db = Firestore.firestore()
    db.collection("rooms").document(roomID).collection("playerData").getDocuments{snapshot, error in
        guard let snapshot = snapshot else { return }
        
        let playerCount = snapshot.documents.compactMap { snapshot in
            try? snapshot.data(as: roomData.self)
        }
        print(playerCount)
        completion(.success(playerCount.count))
    }
}

func fetchplayerInformation(roomID:String, email:String,completion: @escaping(Result<roomData,Error>) -> Void) {
    let db = Firestore.firestore()
    db.collection("rooms").document(roomID).collection("playerData").document(email).getDocument{snapshot, error in
        guard let snapshot = snapshot,snapshot.exists,let playerself = try?snapshot.data(as: roomData.self)else
        {
            if let error = error{
                print("錯誤訊息：",error)
                completion(.failure(error))
            }
            return
        }
        completion(.success(playerself))

    }
}
