//
//  GameView.swift
//  game
//
//  Created by 張凱翔 on 2021/7/5.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var game = Game()
    
    let locations = [
        CGPoint(x: 180, y: 150),//起點
        CGPoint(x: 140, y: 130),
        CGPoint(x: 100, y: 110),
        CGPoint(x: 60, y: 90),
        CGPoint(x: 100, y: 70),
        CGPoint(x: 140, y: 50),
        CGPoint(x: 180, y: 30),
        CGPoint(x: 220, y: 50),
        CGPoint(x: 260, y: 70),
        CGPoint(x: 300, y: 90),
        CGPoint(x: 260, y: 110),
        CGPoint(x: 220, y: 130)
    ]
    
    func location(forPlayerIndex index: Int) -> CGPoint {
        locations[game.players[index].currentLocation]
    }
    
    var body: some View{
        ZStack{
            
            ForEach(locations.indices) { index in
                
                
                GameRoadView()
                    .position(x: locations[index].x, y: locations[index].y)
                
                Image(systemName: "\(index).square")
                    .frame(width: 40, height: 40)
                    .position(x: locations[index].x, y: locations[index].y)
                
                AsyncImage(url: URL(string: "firebaseOfRoomdata.player[index].playerImg)")){ image in
                    image
                        .resizable()
                    .scaledToFit()
                } placeholder: {
                    Image("unknown")
                        .resizable()
                        .scaledToFit()
                }
                    .frame(width: 20, height: 20)
                    .cornerRadius(20)
                    .position(location(forPlayerIndex: 0))
                    .animation(.linear(duration: 0.1))
                
                VStack {
                    Spacer()
                    Button {
                        game.playerMove()
                    } label: {
                        Text("Move")
                    }
                    Spacer()
                }
            }
            
            
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("orange"), Color("darkpink")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(FirebaseDataOfRoom())
            
    }
}
