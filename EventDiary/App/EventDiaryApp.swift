//
//  EventDiaryApp.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/7/22.
//

import SwiftUI
import Firebase

@main
struct EventDiaryApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(EventListViewModel())
                .environmentObject(UserAuthViewModel())
        }
    }
}
