//
//  gameApp.swift
//  game
//
//  Created by 張凱翔 on 2021/6/30.
//

import SwiftUI

@main
struct gameApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
