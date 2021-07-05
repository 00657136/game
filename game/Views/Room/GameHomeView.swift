//
//  GameHomeView.swift
//  game
//
//  Created by 張凱翔 on 2021/7/3.
//

import SwiftUI

struct GameHomeView: View {
    
    @State private var maxCircleHeight: CGFloat = 0
    @State private var TurnToHomeView = false
    @State private var TurnToSettingView = false
    @State private var TurnToSkinView = false
    @State private var TurnToRoomView = false
    @State private var TurnToJoinGameView = false
    @ObservedObject var UserDATA: userData
    @State private var isCreater = false
    @State var inviteNumber = ""
    @State var firebaseDataOfRoom = FirebaseDataOfRoom()
    
    
    var body: some View {
        VStack{
        
            GeometryReader{proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                
                DispatchQueue.main.async {
                    if maxCircleHeight == 0{
                        maxCircleHeight = height
                    }
                }
                
                return AnyView(
                    ZStack{
                        Circle()
                            .fill(Color("dark"))
                            .offset(x: UIScreen.main.bounds.width/2, y: -height / 1.3)
                        Circle()
                            .fill(Color("yellow"))
                            .offset(x: -UIScreen.main.bounds.width/3,y: -height/1.5)
                            .rotationEffect(.init(degrees: -5))
                                     
                    }
                )
            }
            .frame(maxHeight: UIScreen.main.bounds.width)
            
            
            
            
        
            VStack{
                 
                Group {
                    HStack{
                        Spacer()
                        
                        ZStack{
                        
                            
                            AsyncImage(url: URL(string: UserDATA.user.imgURL)){ image in
                                image
                                    .resizable()
                                .scaledToFill()
                            } placeholder: {
                                Image("女人物")
                                    .resizable()
                                    .scaledToFill()
                            }
                            .frame(width:UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.width/2)
                        }
                        Spacer()
                        
                    }
                
                
                HStack{
                    Spacer()
                    Text(UserDATA.user.name)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(Color("dark"))
                    Spacer()
                }
            }
                
                
                
                
                Group{
                    HStack{
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .frame(height: 1)
                        Text("選單")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.black.opacity(0.3))
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .frame(height: 1)
                        
                    }
                    .padding()
                    
                //遊戲功能
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            //建立房間
                            isCreater = true
                            let roomNumberID = Int.random(in: 1000...10000)
                            inviteNumber = String(roomNumberID)
                            //print(roomNumberID)
                            
                            let roomData = roomData(inviteNumber: inviteNumber, playerEmail: UserDATA.user.email, playerName: UserDATA.user.name, playerImg: UserDATA.user.imgURL, isHost: true, isready: true, playerIndex: 0)
                            createRoom(roomData: roomData, inviteNumber: inviteNumber, email: UserDATA.user.email)
                            //print(roomData)
                            let roomCheck = roomCheck(roomNumber: inviteNumber, isGameStart: false, money: 30000)
                            createRoomCheck(roomCheck: roomCheck, inviteNumber: inviteNumber)
                            firebaseDataOfRoom.playerself = roomData
                            //firebaseDataOfRoom.player.append(roomData)
                            
                            TurnToRoomView = true
                            
                        }){
                        
                            VStack(alignment: .center, spacing: 5){
                                ZStack{
                                
                                    Circle()
                                        .fill(Color("yellow"))
                                        .frame(width:UIScreen.main.bounds.width/6,height: UIScreen.main.bounds.width/6)
                                        
                                    
                                    Image("home")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                        
                                }
                                Text("建房")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                        }
                        .fullScreenCover(isPresented: $TurnToRoomView, content: {RoomView(email: $UserDATA.user.email, isCreater: $isCreater, inviteNumber: $inviteNumber, UserDATA: UserDATA, firebaseOfRoomdata: firebaseDataOfRoom)})
                        
                        Spacer()
                        
                        Button(action: {
                            
                            
                            TurnToJoinGameView = true
                        }){
                            VStack(alignment: .center, spacing: 5){
                                ZStack{
                                
                                    Circle()
                                        .fill(Color("yellow"))
                                        .frame(width:UIScreen.main.bounds.width/6,height: UIScreen.main.bounds.width/6)
                                        
                                    
                                    Image("loupe")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                        
                                }
                                Text("跟房")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                        }
                        .fullScreenCover(isPresented: $TurnToJoinGameView, content: {JoinGameView(UserDATA:UserDATA)})
                        
                        
                        
                        Spacer()
                        
                        Button(action: {
                            TurnToSkinView = true
                        }){
                            VStack(alignment: .center, spacing: 5){
                                ZStack{
                                
                                    Circle()
                                        .fill(Color("yellow"))
                                        .frame(width:UIScreen.main.bounds.width/6,height: UIScreen.main.bounds.width/6)
                                        
                                    
                                    Image("clothes")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                        
                                }
                                Text("換裝")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                        }
                        .fullScreenCover(isPresented: $TurnToSkinView, content: {SkinView(UserDATA: UserDATA)})
                        
                        Spacer()
                        
                    }
                }
                
                Group{
                    HStack{
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .frame(height: 1)
                        Text("帳號")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.black.opacity(0.3))
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .frame(height: 1)
                        
                    }
                    .padding()
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            TurnToSettingView = true
                        }){
                            VStack(alignment: .center, spacing: 5){
                                ZStack{
                                
                                    Circle()
                                        .fill(Color("dark").opacity(0.9))
                                        .frame(width:UIScreen.main.bounds.width/6,height: UIScreen.main.bounds.width/6)
                                        
                                    
                                    Image("user")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                        
                                }
                                Text("個人資料")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                        }
                        .fullScreenCover(isPresented: $TurnToSettingView, content: {SettingView(UserDATA: UserDATA)})
                        
                        Spacer()
                        
                        Button(action: {
                            SignOut()
                            TurnToHomeView = true
                        }){
                            VStack(alignment: .center, spacing: 5){
                                ZStack{
                                
                                    Circle()
                                        .fill(Color("dark").opacity(0.9))
                                        .frame(width:UIScreen.main.bounds.width/6,height: UIScreen.main.bounds.width/6)
                                        
                                    
                                    Image("log-out")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                        
                                }
                                Text("登出")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                        }
                        .fullScreenCover(isPresented: $TurnToHomeView, content: {HomeView()})
                        
                        Spacer()
                    }
                    
                }
                
                
            }
            .padding()
            .padding(.top,-maxCircleHeight / (UIScreen.main.bounds.height < 750 ? 1.5 : 1.6))
            .frame(maxHeight: .infinity, alignment: .top)
            
        }
        .overlay(
            HStack{
                
                
            }
            .padding(.bottom,getSafeArea().bottom == 0 ? 15 : 0)
            , alignment:.bottom
            
        )
        .background(
            HStack{
                
                Circle()
                    .fill(Color("yellow"))
                    .frame(width: 70, height: 70)
                    .offset(x:-30,y: UIScreen.main.bounds.height < 750 ? 10 : 0)
                
                Spacer()
                
                Circle()
                    .fill(Color("dark"))
                    .frame(width: 110, height: 110)
                    .offset(x:40,y:20)
                
            }.offset(y: getSafeArea().bottom+30)
            , alignment:.bottom
        
        )
        
        
    }
}

struct GameHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GameHomeView(UserDATA: userData())
            .environmentObject(userData())
            .environmentObject(FirebaseDataOfRoom())
    }
}
