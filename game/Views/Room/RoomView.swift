//
//  RoomView.swift
//  game
//
//  Created by 張凱翔 on 2021/7/4.
//

import SwiftUI

struct RoomView: View {
    @Binding var email :String
    @Binding var isCreater: Bool
    @Binding var inviteNumber: String
    @ObservedObject var UserDATA: userData
    @State private var TurnToGameHome = false
    @State private var TurnToGameView = false
    let exitNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("Player exit"))
    let startNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("game start"))

    @ObservedObject var firebaseOfRoomdata : FirebaseDataOfRoom
    
    @State var couldStartGameBtndisable = true
    @State var showChangeRole = false
    
    var body: some View {
        VStack{
            
            HStack(alignment: .top){
                
                Button(action: {
                    firebaseOfRoomdata.deleteplayer(roomID: inviteNumber, email: email)
                    NotificationCenter.default.post(name: NSNotification.Name("Player exit"), object: nil)
                    //TurnToGameHome = true
                }, label: {
                    VStack(alignment: .center, spacing: 5){
                        Image(systemName: "arrow.backward.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width/15, height: UIScreen.main.bounds.width/15)
                    
                        Text("離開")
                            .foregroundColor(Color.white)
                        
                    }
                })
                    .fullScreenCover(isPresented: $TurnToGameHome, content: {GameHomeView(UserDATA: UserDATA)})
                
                
                Spacer()
                
                VStack(alignment: .center, spacing: 5){
                    Text("遊戲房間")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.white)
                    Text("邀請碼："+inviteNumber)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = inviteNumber
                }, label: {
                    VStack(alignment: .center, spacing: 5){
                        Image(systemName: "doc.on.clipboard.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width/15, height: UIScreen.main.bounds.width/15)
                    
                        Text("複製")
                            .foregroundColor(Color.white)
                        
                    }
                })
                
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                                
                ForEach(0..<4){index in

                    playerView(index: index)
                        .environmentObject(firebaseOfRoomdata)
                    
                }
                
                Button(action: {
                    if firebaseOfRoomdata.playerself.isHost{
                        firebaseOfRoomdata.changeIsReady(roomID: inviteNumber, email: email)
                        firebaseOfRoomdata.changeGameToStart(roomID: inviteNumber)
                        NotificationCenter.default.post(name: Notification.Name("game start"), object: nil)
                    }else{
                        firebaseOfRoomdata.playerself.isready.toggle()
                        firebaseOfRoomdata.changeIsReady(roomID: inviteNumber, email: email)
                    }
                    
                }, label: {
                    
                    HStack(alignment: .center, spacing: 5){
                        Spacer()
                        //bug
                        Text(firebaseOfRoomdata.playerself.isHost ? "開始遊戲" : firebaseOfRoomdata.playerself.isready ? "取消準備" : "準備")
                            .font(.system(size: 18))
                            .foregroundColor(Color("dark"))
                        
                        Spacer()
                        
                    }
                    .padding()
                    .background(
                        !firebaseOfRoomdata.playerself.isHost ? Color("lightblue") : couldStartGameBtndisable ? .gray : Color("lightblue")
                    )
                    .cornerRadius(30)
                        
                })
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.top,10)
                .disabled(firebaseOfRoomdata.playerself.isHost ? couldStartGameBtndisable : false)
                .fullScreenCover(isPresented: $TurnToGameView, content: {GameView()})
                
                
                
                
                
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color("orange"), Color("darkpink")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.bottom)
        
        //初始
        .onAppear(){

            firebaseOfRoomdata.checkRoomsChange(roomID: inviteNumber){ result in
                switch result{
                case .success(let changeType):
                    if changeType == "removed"{
                        if firebaseOfRoomdata.player.isEmpty{
                            firebaseOfRoomdata.deleteroom(roomID: inviteNumber)
                        }
                    }else if changeType == "modified"{
                        var temp = false
                        for i in firebaseOfRoomdata.player.indices {
                            if !firebaseOfRoomdata.player[i].isready {
                                temp = true
                            }
                        }
                        couldStartGameBtndisable = temp
                    }else if changeType == "added"{
                        
                    }
                case .failure(_):
                    break
                }
            }
            firebaseOfRoomdata.checkGameStart(roomID: inviteNumber) { result in
                switch result{
                case .success(let roomCheck):
                    if roomCheck.isGameStart{
                        
                        print("成功")
                        NotificationCenter.default.post(name: NSNotification.Name("game start"), object: nil)
                    }
                    print("失敗")
                case .failure(_):
                    break
                }
            }
            
            
        }
        
        .onReceive(exitNotificaiton, perform: { _ in
                   print("Host Exit")

            TurnToGameHome = true

                   })
       //遊戲
//        .onReceive(startNotificaiton, perform: { _ in
//            print("Start")
//
//         let gamePlayer = GamePlayer(rolePosition: 0, goAhead: 0, isChangeToYou: firebaseOfRoomdata.playerself.isHost ? true : false, money: 30000, house: "0", playerIndex: firebaseOfRoomdata.playerself.playerIndex)
//         var gameMapInformation = GameMapInformation( mapIndex: 0, showBuy: false, whoBuyIndex: 0, whoBuyName: "non", houseLevel: 0)
//         var gameMapInformationMatrix = [GameMapInformation]()
//         for i in 0..<16{
//             gameMapInformation.mapIndex = i
//             gameMapInformationMatrix.append(gameMapInformation)
//         }
//
//         createGameMap(roomNumber: inviteNumber, mapItemNumbrt: 16, gameMapInmformation: gameMapInformationMatrix)
//         createGamePlayer(roomNumber: inviteNumber, email: email, gamePlayer: gamePlayer)
//         DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//          TurnToGameView = true
//
//         }
//        })

        
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(email: .constant(""), isCreater: .constant(true), inviteNumber: .constant(""), UserDATA: userData(), firebaseOfRoomdata: FirebaseDataOfRoom())
            .environmentObject(userData())
            .environmentObject(FirebaseDataOfRoom())
    }
}


struct playerView: View{
    @EnvironmentObject var firebaseOfRoomdata : FirebaseDataOfRoom
    var index: Int = 0
    
    var body: some View{
        HStack{
            
                                
            if index < firebaseOfRoomdata.player.count{
                AsyncImage(url: URL(string: firebaseOfRoomdata.player[index].playerImg)){ image in
                    image
                        .resizable()
                    .scaledToFit()
                } placeholder: {
                    Image("unknown")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: UIScreen.main.bounds.width / 2.5)
                .cornerRadius(UIScreen.main.bounds.width / 2.5)
            }
            
            else{
                Image("unknown")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 2.5)
            }
            
            Spacer()
            
            if index < firebaseOfRoomdata.player.count{
                VStack(alignment: .center,spacing: 15){
                    VStack(alignment: .center,spacing: 5){
                        Text("玩家名稱:")
                            .font(.system(size: 22))
                            .foregroundColor(Color("dark"))
                        Text(firebaseOfRoomdata.player[index].playerName)
                            .font(.system(size: 22))
                            .foregroundColor(Color("dark"))
                    }
                
                
                
                
                    Text(firebaseOfRoomdata.player[index].isHost ? "房主": "準備")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color("dark"))
                        .padding()
                        .background(
                            firebaseOfRoomdata.player[index].isready ?
                                LinearGradient(gradient: Gradient(colors: [Color("yellow"), Color("lightblue")]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                            :
                                LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                        )
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1.5))
                
                }
                
            }
            Spacer()
            
        }
        .frame(height: 290)
        .background(
        
            Color.white.opacity(0.2)
            .cornerRadius(25)
            .rotation3DEffect(.init(degrees: 20), axis: (x: 0, y: -1, z: 0))
            .padding(.vertical, 35)
            .padding(.trailing, 25)
            
        )
        .padding(.horizontal)

    }
}
