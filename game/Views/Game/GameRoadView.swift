//
//  GameRoadView.swift
//  game
//
//  Created by 張凱翔 on 2021/7/5.
//

import SwiftUI

struct GameRoadView: View {
    @State var size = CGSize(width: 40, height: 40)
    //@Binding var roadText :String
    var body: some View {
      
        
            IsometricView(active: true, extruded: true, depth: 10) {
                ZStack{
                   
                    Rectangle()
                        .stroke()
//                    Text(roadText)
//                        .font(.footnote)
//                        .fontWeight(.bold)
//                        .multilineTextAlignment(.center)
//                        .frame(width: 55)
                        
                }
                
            }
            
            .frame(width: size.width, height: size.height, alignment: .center)
            .scaledToFit()
        
    }
    
}

struct GameRoadView_Previews: PreviewProvider {
    static var previews: some View {
        GameRoadView()
            
    }
}
