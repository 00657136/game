//
//  CreatRoleView.swift
//  game
//
//  Created by 張凱翔 on 2021/7/3.
//

import SwiftUI
import Lottie

struct CreatRoleView: View {
    @State private var maxCircleHeight: CGFloat = 0
    @State private var name = ""
    @State private var selectedIndex = 0
    @State private var gender = ["男","女"]
    @State var UserDATA = UserData(email: "", password: "", name: "", gender: "", hair: "", body: "", shoes: "", imgURL: "")
    @State var email : String
    @State var userDATA = userData()
    @State var TurnToGameHomeView = false
    
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
                    
                    LottieView(name: "list", loopMode: .loop)
                        .frame(width:UIScreen.main.bounds.width*4/5,height: UIScreen.main.bounds.width*4/5)
                        .offset(y:-130)
                        
                    Group{
                        Group{
                            HStack{
                                
                                Rectangle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(height: 1)
                                Text("設定個人資料")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.3))
                                Rectangle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(height: 1)
                                
                            }
                            .padding()
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 5){
                            
                            Text("名稱")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color("dark"))

                            TextField("請在此填入名稱",text: $name)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color("dark"))
                                .padding(.top,5)
                                
                                
                            Divider()
                        }
                        
                        VStack(alignment: .leading, spacing: 10){
                            
                            Text("性別")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color("dark"))

                            Picker("",selection: $selectedIndex){
                                ForEach(0..<gender.count){(index) in
                                    Text(self.gender[index])
                                    
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .background(Color("yellow"))
                                
                                
                            Divider()
                        }
                        
                        Button(action: {
                    
                            UserDATA.email = email
                            UserDATA.name = name
                            UserDATA.gender = gender[selectedIndex]
                            creatUser(store: UserDATA, email: email)
                            
                            fetchPlayers(email: email){ result in
                                switch result {
                                    case .success(let player):
                                    userDATA.user = player
                                    print(userDATA.user)
                                    case .failure(let error):
                                        print("抓取失敗")
                                        print(error)
                                    break
                                }
                                
                            }
                            
                            TurnToGameHomeView = true
                            
                        }, label: {
                            
                            HStack(alignment: .center, spacing: 5){
                                Spacer()
                                
                                Text("設定完成")
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
                        .fullScreenCover(isPresented: $TurnToGameHomeView, content: {GameHomeView(UserDATA: userDATA)})
                    }
                    .offset(y:-200)
                
                
                
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

struct CreatRoleView_Previews: PreviewProvider {
    static var previews: some View {
        CreatRoleView(email: "")
            .environmentObject(userData())
    }
}
