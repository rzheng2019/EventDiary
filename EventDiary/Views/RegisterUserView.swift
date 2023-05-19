//
//  RegisterUserView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 2/21/23.
//

import SwiftUI
import Firebase

struct RegisterUserView: View {
    @State var email : String
    @State var password : String
    
    var body: some View {
        VStack {
            EventDiarySignUpView()
            
            CredentialFieldsView(email: $email, password: $password)
            
            SignUpButtonView(email: $email, password: $password)
        }
    }
}

struct EventDiarySignUpView : View {
    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    var body: some View {
        ZStack {
            Image(systemName: "book")
                .opacity(0.2)
                .font(.system(size: 300))
                .frame(width: 150, height: 150)
                .padding(.top, 100)
                .foregroundColor(Color(hikerBackgroundColor))
            
            HStack {
                Text("New")
                    .font(.custom("Georgia", size: 50))
                    .bold()
                    .padding(.top, 100)
                    .padding(.leading, 0.5)
                    .foregroundColor(Color(hikerBackgroundColor))
                
                Text("User")
                    .font(.custom("Georgia", size: 50))
                    .bold()
                    .padding(.top, 100)
                    .padding(.leading, 25)
                    .foregroundColor(Color(hikerBackgroundColor))
            }
        }
    }
}

struct SignUpButtonView : View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    @State private var showingAlert = false
    @State var registerStatus: Bool = true
    @State var buttonPressedStatus : Bool = false
    
    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    @Binding var email : String
    @Binding var password: String
    
    var body: some View {
        Button(action: {
            buttonPressedStatus = true
            
            userAuthViewModel.signUp(email: email, password: password)
            
            // Reset email and password fields after every successful sign up
            email = ""
            password = ""
            
        }, label: {
            ZStack {
                if userAuthViewModel.signUpFailure == true {
                    VStack {
                        HStack {
                            Text("Did not meet one or more of the following criteria: ")
                                .font(.system(size: 15))
                                .foregroundColor(Color.red)
                                .padding(.leading, 18)
                        }
                        HStack {
                            Text("(1) Email already in use. Please use a different email.")
                                .font(.system(size: 15))
                                .foregroundColor(Color.red)
                                .padding(.leading, 31)
                        }
                        HStack {
                            Text("(2) Password is not at least 6 characters long")
                                .font(.system(size: 15))
                                .foregroundColor(Color.red)
                                .padding(.trailing, 19)
                                .padding(.bottom, 135)
                        }
                    }
                    VStack {
                        Text("Sign Up")
                            .font(.custom("Georgia", size: 25))
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 275, height: 50)
                            .background(Color(hikerBackgroundColor))
                            .cornerRadius(150)
                    }
                }
                else {
                    if buttonPressedStatus == false {
                        VStack {
                            Text("Sign Up")
                                .font(.custom("Georgia", size: 25))
                                .foregroundColor(.black)
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(width: 275, height: 50)
                                .background(Color(hikerBackgroundColor))
                                .cornerRadius(150)
                        }
                    }
                    else {
                        VStack {
                            ProgressView("Creating account ...")
                                .padding(.bottom, 5)
                            
                            Text("Sign Up")
                                .font(.custom("Georgia", size: 25))
                                .foregroundColor(.black)
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(width: 275, height: 50)
                                .background(Color(hikerBackgroundColor))
                                .cornerRadius(150)
                        }
                    }
                }
            }
        })
        
        Spacer()
    }
}

struct RegisterUserView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterUserView(email: "", password: "")
            .environmentObject(UserAuthViewModel())
    }
}
