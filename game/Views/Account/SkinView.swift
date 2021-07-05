//
//  SkinView.swift
//  game
//
//  Created by 張凱翔 on 2021/7/4.
//

import SwiftUI

struct SkinView: View {
    
    @State private var gender = ["男","女"]
    @State private var MaleHair = ["男金髮","男褐髮","男黑髮"]
    @State private var MaleBody = ["男服2","男服3"]
    @State private var MaleShoes = ["男鞋2","男鞋3"]
    @State private var FemaleHair = ["金髮","褐髮","黑髮"]
    @State private var FemaleBody = ["女服1","女服2","女服3"]
    @State private var FemaleShoes = ["女鞋1","女鞋2"]
    @State private var selectedGenderIndex = 0
    @State private var selectedMaleHairIndex = 0
    @State private var selectedMaleBodyIndex = 0
    @State private var selectedMaleShoesIndex = 0
    @State private var selectedFemaleHairIndex = 0
    @State private var selectedFemaleBodyIndex = 0
    @State private var selectedFemaleShoesIndex = 0
    @State private var skinImage: UIImage?
    @ObservedObject var UserDATA: userData
    @State private var TurnToGameHome = false
    
    
    var skinView: some View {
        ZStack{
            if selectedGenderIndex == 1{
                ZStack{
                    Image(FemaleHair[selectedFemaleHairIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width:UIScreen.main.bounds.width*5/6,height: UIScreen.main.bounds.width*5/6)
                    Image(FemaleBody[selectedFemaleBodyIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width:UIScreen.main.bounds.width*5/6,height: UIScreen.main.bounds.width*5/6)
                    Image(FemaleShoes[selectedFemaleShoesIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width:UIScreen.main.bounds.width*5/6,height: UIScreen.main.bounds.width*5/6)
                    
                }
            }
            else{
                ZStack{
                    Image(MaleHair[selectedMaleHairIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width:UIScreen.main.bounds.width*5/6,height: UIScreen.main.bounds.width*5/6)
                    Image(MaleBody[selectedMaleBodyIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width:UIScreen.main.bounds.width*5/6,height: UIScreen.main.bounds.width*5/6)
                    Image(MaleShoes[selectedMaleShoesIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width:UIScreen.main.bounds.width*5/6,height: UIScreen.main.bounds.width*5/6)
                    
                }
                
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top){
                
            LinearGradient(gradient: Gradient(colors: [Color("yellow"), Color.white]), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 10){
                
                Spacer()
                
                
                HStack{
                    Spacer()
                    //紙娃娃
                    
                    skinView
                        .overlay(
                            HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                if selectedGenderIndex == 1{
                                    selectedFemaleHairIndex = Int.random(in: 0..<3)
                                    selectedFemaleBodyIndex = Int.random(in: 0..<3)
                                    selectedFemaleShoesIndex = Int.random(in: 0..<2)
                                }
                                else{
                                    selectedMaleHairIndex = Int.random(in: 0..<3)
                                    selectedMaleBodyIndex = Int.random(in: 0..<2)
                                    selectedMaleShoesIndex = Int.random(in: 0..<2)
                                }
                            }){
                            
                                VStack(alignment: .center, spacing: 5){
                                    ZStack{
                                    
                                        Circle()
                                            .fill(Color("background"))
                                            .frame(width:UIScreen.main.bounds.width/6,height: UIScreen.main.bounds.width/6)
                                            
                                        
                                        Image("dice")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                            
                                    }
                                    Text("隨機生成")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color.black.opacity(0.7))
                                }
                            }
                            
                            
                            }
                            , alignment:.bottom
                        )
                    
                    Spacer()
                    
                }
                
                HStack{
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(height: 1)
                    Text("設定角色造型")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.3))
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(height: 1)
                    
                }
                .padding()
                
                Picker("",selection: $selectedGenderIndex){
                    ForEach(0..<gender.count){(index) in
                        Text(self.gender[index])
                        
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color("yellow"))
                .padding()
                
                if selectedGenderIndex == 1{
                    VStack(spacing:10){
                        Picker("",selection: $selectedFemaleHairIndex){
                            ForEach(0..<FemaleHair.count){(index) in
                                Text(self.FemaleHair[index])
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color("yellow"))
                        
                        
                        Picker("",selection: $selectedFemaleBodyIndex){
                            ForEach(0..<FemaleBody.count){(index) in
                                Text(self.FemaleBody[index])
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color("yellow"))
                        
                        
                        Picker("",selection: $selectedFemaleShoesIndex){
                            ForEach(0..<FemaleShoes.count){(index) in
                                Text(self.FemaleShoes[index])
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color("yellow"))
                        
                    }
                    .padding()
                }
                else{
                    VStack(spacing:10){
                        Picker("",selection: $selectedMaleHairIndex){
                            ForEach(0..<MaleHair.count){(index) in
                                Text(self.MaleHair[index])
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color("yellow"))
                        
                        
                        Picker("",selection: $selectedMaleBodyIndex){
                            ForEach(0..<MaleBody.count){(index) in
                                Text(self.MaleBody[index])
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color("yellow"))
                        
                        
                        Picker("",selection: $selectedMaleShoesIndex){
                            ForEach(0..<MaleShoes.count){(index) in
                                Text(self.MaleShoes[index])
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color("yellow"))
                        
                    }
                    .padding()
                }
                
                Button(action: {
                    skinImage = skinView.snapshot()
                    
                    uploadPhoto(image: skinImage!){result in
                        switch result{
                        case .success(let url):
                            //setUserPhoto(url: url)
                            
                            modifyImgURL(email: UserDATA.user.email, url: "\(url)")
                            UserDATA.user.imgURL = "\(url)"
                            
                            TurnToGameHome = true
                        case .failure(let error):
                            print(error)
                            
                        }
                        
                    }
                    
                    
                }, label: {
                    
                    HStack(alignment: .center, spacing: 5){
                        Spacer()
                        
                        Text("上傳")
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
                
                
                Spacer()
            }
            .padding()
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SkinView_Previews: PreviewProvider {
    static var previews: some View {
        SkinView(UserDATA: userData())
            .environmentObject(userData())
    }
}


extension View{
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
