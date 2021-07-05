//
//  HomeView.swift
//  game
//
//  Created by 張凱翔 on 2021/6/30.
//

import SwiftUI
import SSSwiftUIGIFView

struct HomeView: View {
    @State private var showSignUp = false
    @State private var maxCircleHeight: CGFloat = 0
    
    
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
                    
                    SwiftUIGIFPlayerView(gifName: "girl")
                        .frame(width: UIScreen.main.bounds.width*3/4, height: UIScreen.main.bounds.height/2)
                        .scaledToFill()
                        
                    
                        
                    }
                )
            }
            .frame(maxHeight: UIScreen.main.bounds.width)
            
            
            
            
        
            ZStack{
                 
                
                if showSignUp == true{
                    SignUpView()
                        .transition(.move(edge: .trailing))
                }
                else{
                    LoginView(UserDATA: userData())
                        .transition(.move(edge: .trailing))
                }
                
            }
            .padding()
            .padding(.top,-maxCircleHeight / (UIScreen.main.bounds.height < 750 ? 1.5 : 1.6))
            .frame(maxHeight: .infinity, alignment: .top)
            
        }
        .overlay(
            HStack{
                Text(showSignUp ? "已經有帳號嗎？" : "還沒有帳號嗎？")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray)
                
                Button(action: {
                    withAnimation{
                        showSignUp.toggle()
                    }
                }, label: {
                    Text(showSignUp ? "登入" : "註冊")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("background"))
                })
                
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()

    }
}
