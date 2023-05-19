//
//  LoadingEventListView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 3/15/23.
//

import SwiftUI

struct LoadingEventListView: View {
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    @State var eventListReady : Bool = false
    
    var body: some View {
        VStack {
            if eventListReady == false {
                ProgressView("Loading account information ...")
                    .font(.custom("Georgia", size: 18))
                    .bold()
                    .foregroundColor(Color.black)
                    .frame(width: 300)
            }
            else {
                EventListView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                eventListReady = userAuthViewModel.signedIn
            }
        }
    }
}

struct LoadingEventListView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingEventListView()
    }
}
