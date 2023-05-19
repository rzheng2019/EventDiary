//
//  LogoView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 3/17/23.
//

import SwiftUI

struct AppLogoView: View {
    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Image(systemName: "")
                    .opacity(0.2)
                    .font(.system(size: 300))
                    .frame(width: 150, height: 150)
                    .padding(.top, 100)
                    .foregroundColor(Color(hikerBackgroundColor))
                
                VStack {
                    Text("Event")
                        .font(.custom("Georgia", size: 70))
                        .bold()
                        .padding(.top, 90)
                        .foregroundColor(Color(hikerBackgroundColor))
                    
                    Text("Diary")
                        .font(.custom("Georgia", size: 70))
                        .bold()
                        .foregroundColor(Color(hikerBackgroundColor))
                }
            }
            .padding(.bottom, 100)
            
            Spacer()
        }
    }
}

struct AppLogoView_Previews: PreviewProvider {
    static var previews: some View {
        AppLogoView()
    }
}
