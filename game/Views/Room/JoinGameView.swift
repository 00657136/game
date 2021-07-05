//
//  JoinGameView.swift
//  game
//
//  Created by 張凱翔 on 2021/7/4.
//

import SwiftUI

struct JoinGameView: View {
    @State private var maxCircleHeight: CGFloat = 0
    @State private var inviteNumber = ""
    @ObservedObject var UserDATA: userData
    @State private var TurnToGameHome = false
    @State private var TurnToRoomView = false
    @State var isCreater = false
    @State var showAlert = false
    @State var alertMessage = ""
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
            
            
            
            
        
            ZStack{
                
                VStack(alignment: .center, spacing: 20){
                    
                    LottieView(name: "search", loopMode: .loop)
                        .frame(width:UIScreen.main.bounds.width*4/5,height: UIScreen.main.bounds.width*4/5)
                        .offset(y:-130)
                        
                    Group{
                        Group{
                            HStack{
                                
                                Rectangle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(height: 1)
                                Text("跟房")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.3))
                                Rectangle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(height: 1)
                                
                            }
                            .padding()
                        }
                        
                        VStack(alignment: .leading, spacing: 5){
                            
                            Text("邀請碼")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color("dark"))

                            TextField("請在此填入房間邀請碼",text: $inviteNumber)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color("dark"))
                                .padding(.top,5)
                                
                                
                            Divider()
                        }
                        
                        
                        Button(action: {
                            
                            
                                checkRoomexist(roomID: inviteNumber) { result in
                                    switch result {
                                    case .success(let isExist):
                                        if isExist{
                                            
                                            checkRoomPlayerNumber(roomID: inviteNumber) { result in
                                                switch result{
                                                case .success(let int):
                                                    if int < 4{
                                                        let roomData = roomData(inviteNumber: inviteNumber, playerEmail: UserDATA.user.email, playerName: UserDATA.user.name, playerImg: UserDATA.user.imgURL, isHost: false, isready: false, playerIndex: int)
                                                        createRoom(roomData: roomData, inviteNumber: inviteNumber, email: UserDATA.user.email)
                                                        
                                                        //firebaseDataOfRoom.player = [roomData]
                                                        firebaseDataOfRoom.playerself = roomData
                                                        TurnToRoomView = true
                                                    }else{
                                                        alertMessage = "房間已滿"
                                                        showAlert = true
                                                    }
                                                    
                                                case .failure(_):
                                                    break
                                                }
                                            }
                                            
                                            
                                        }else{
                                            alertMessage = "房間不存在1"
                                            showAlert = true
                                        }
                                        
                                        
                                    case .failure(let error):
                                        
                                        alertMessage = "房間不存在2"
                                        showAlert = true
                                        print(error)
                                        
                                        break
                                    }
                                }
                            
                            
                        }, label: {
                            
                            HStack(alignment: .center, spacing: 5){
                                Spacer()
                                
                                Text("加入房間")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.white)
                                
                                Spacer()
                                
                            }
                            .padding()
                            .background(Color("dark"))
                            .cornerRadius(30)
                                
                        })
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.top,10)
                        .fullScreenCover(isPresented: $TurnToRoomView, content: {RoomView(email: $UserDATA.user.email, isCreater: $isCreater, inviteNumber: $inviteNumber, UserDATA: UserDATA, firebaseOfRoomdata: firebaseDataOfRoom)})
                        
                        
                        
                        
                        
                        
                    }
                    .offset(y:-200)
                
                
                
                }
                
            }
            .padding()
            .padding(.top,-maxCircleHeight / (UIScreen.main.bounds.height < 750 ? 1.5 : 1.6))
            .frame(maxHeight: .infinity, alignment: .top)
            
        }
        .alert(isPresented: $showAlert, content: {() -> Alert in
            let answer = alertMessage
            return Alert(title: Text(answer))
        })
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
            
            Button(action: {
                
                TurnToGameHome = true
            }, label: {
                VStack(alignment: .center, spacing: 5){
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color("dark"))
                        .frame(width: UIScreen.main.bounds.width/8, height: UIScreen.main.bounds.width/8)
                
                    Text("離開")
                        .foregroundColor(Color("dark"))
                    
                }
            })
                .offset(x:20,y:-50)
                .fullScreenCover(isPresented: $TurnToGameHome, content: {GameHomeView(UserDATA: UserDATA)})
            
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

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView(UserDATA: userData())
            .environmentObject(userData())
    }
}
