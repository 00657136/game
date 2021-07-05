//
//  LoginView.swift
//  game
//
//  Created by 張凱翔 on 2021/6/30.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var visible = false
    @State private var showAlert = false
    @State private var errorMsg = ""
    @ObservedObject var UserDATA: userData
    @State private var TurnToGameHome = false
    
    var body: some View {
        VStack{
            //標題........
            Text("登入")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color("dark"))
                .kerning(10)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            //信箱..........
            VStack(alignment: .leading, spacing: 5){
                
                Text("信箱")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray)

                TextField("請在此填入信箱",text: $email)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("dark"))
                    .padding(.top,5)
                    
                    
                Divider()
            }
            .padding(.top,25)
            
            //密碼.........
            VStack(alignment: .leading, spacing: 5){
                
                Text("密碼")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray)
                
                HStack{
                    
                    if visible {
                        TextField("請在此填入密碼",text: $password)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("dark"))
                            .padding(.top,5)
                    }
                    else{
                        SecureField("請在此填入密碼",text: $password)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("dark"))
                            .padding(.top,5)
                    }
                    
                    
                    Button(action: {
                        
                        self.visible.toggle()
                        
                    }){
                        
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color("dark").opacity(0.7))
                        
                    }
                    
                }
                
                Divider()
            }
            .padding(.top,25)
            
            //忘記密碼......
            Button(action: {}, label: {
                Text("忘記密碼?")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray)
            })
            .frame(maxWidth: .infinity,alignment: .trailing)
            .padding(.top,10)
            
            //下一頁......
            Button(action: {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                     guard error == nil else {
                         print(error?.localizedDescription ?? "")
                         errorMsg = error?.localizedDescription ?? ""
                         showAlert = true
                        return
                     }
                    fetchPlayers(email: email){ result in
                        switch result {
                            case .success(let player):
                            UserDATA.user = player
                            print(UserDATA.user)
                            case .failure(let error):
                                print("抓取失敗")
                                print(error)
                            break
                        }
                        
                    }
                    TurnToGameHome = true
                }
            }, label: {
                
                HStack(alignment: .center, spacing: 5){
                    Spacer()
                    
                    Text("登入")
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
            .alert(isPresented: $showAlert){ () -> Alert in
                return Alert(title: Text(errorMsg))
            }
            .fullScreenCover(isPresented: $TurnToGameHome, content: {GameHomeView(UserDATA: UserDATA)})
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(UserDATA: userData())
            
    }
}
