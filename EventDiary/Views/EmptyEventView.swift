//
//  HomeScreen.swift
//  EventDiary
//
//  Created by Ricky Zheng on 10/10/22.
//

import SwiftUI
import Firebase

struct EmptyEventView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var eventListViewModel : EventListViewModel
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    let titleString: String = "Board"
    let emptyEventBoardDescriptionL1: String = "Look's like there isn't any events!"
    let emptyEventBoardDescriptionL2: String = "Let's add some great times!"
    
    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    @State private var showingAlert : Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                // Background Color of Home Page
                Image(systemName: "figure.hiking")
                    .opacity(0.1)
                    .foregroundColor(Color(hikerBackgroundColor))
                    .frame(width: 200, height: 130)
                    .font(.system(size: 350))
                
                VStack {
                    Spacer()
                    
                    Text(emptyEventBoardDescriptionL1)
                        .font(.system(size: 17))
                        .fontWeight(.light)
                        .foregroundColor(Color.black)
                        .padding(.top, 100)
                    
                    Text(emptyEventBoardDescriptionL2)
                        .font(.system(size: 17))
                        .fontWeight(.light)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
            }
            
            Button {

            } label: {
                NavigationLink(destination: AddEventView(), label: {
                    Text("+ Add Event \(Image(systemName: "figure.hiking"))")
                        .foregroundColor(.black)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 200, height: 50)
                        .background(Color(hikerBackgroundColor))
                        .cornerRadius(150)
                })
            }

            Button(action: {
                showingAlert = true
            }, label: {
                Text("Log Out")
                    .foregroundColor(Color.red)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Are you sure you want to log out?"),
                      primaryButton: .destructive(Text("Log Out")) {
                    userAuthViewModel.signOut()
                },
                      secondaryButton: .cancel())
            }
            
        }
    }
}

struct EmptyEventView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyEventView()
        }
        .environmentObject(EventListViewModel())
        .environmentObject(UserAuthViewModel())
    }
}
