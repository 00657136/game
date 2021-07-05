//
//  SettingView.swift
//  game
//
//  Created by 張凱翔 on 2021/7/3.
//

import SwiftUI
import CoreMIDI

struct SettingView: View {
    @State private var maxCircleHeight: CGFloat = 0
    @State private var name = ""
    @State private var selectedIndex = 0
    @State private var gender = ["男","女"]
    @ObservedObject var UserDATA: userData
    @State private var TurnToGameHome = false
    
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
                    
                    Group {
                        HStack{
                            Spacer()
                            
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
                            Text("修改個人資料")
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
                
                        modifyUserData(email: UserDATA.user.email, name: name, gender: gender[selectedIndex])
                        
                        UserDATA.user.name = name
                        UserDATA.user.gender = gender[selectedIndex]
                        
                        TurnToGameHome = true
                        
                    }, label: {
                        
                        HStack(alignment: .center, spacing: 5){
                            Spacer()
                            
                            Text("儲存")
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
                    .fullScreenCover(isPresented: $TurnToGameHome, content: {GameHomeView(UserDATA: UserDATA)})
                
                
                
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

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(UserDATA: userData())
            .environmentObject(userData())
    }
}
