//
//  SplashScreenView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 3/2/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            if isActive {
                LoginPageView()
            }
            else {
                VStack {
                    VStack {
                        Spacer()
                        EventDiaryTitleView()
                            .padding(.bottom, 100)
                        Spacer()
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
