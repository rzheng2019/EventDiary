//
//  LoginPageView.swift
//  EventDiary
//
//  Created by Ricky Zheng on 2/20/23.
//

import SwiftUI
import Firebase

struct LoginPageView: View {
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    @State var email : String = ""
    @State var password : String = ""
    
    var body: some View {
        //NavigationView {
            if !userAuthViewModel.signedIn {
                VStack {
                    EventDiaryTitleView()
                    
                    CredentialFieldsView(email: $email,
                                         password: $password)

                    SignInView(email: $email,
                               password: $password)
                    
                    SignUpView(email: email,
                               password: password)
                }
            }
            else {
                LoadingEventListView()
            }
        //}
    }
}

struct EventDiaryTitleView : View {
    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    var body: some View {
        ZStack {
            Image(systemName: "")
                .opacity(0.2)
                .font(.system(size: 300))
                .frame(width: 150, height: 150)
                .padding(.top, 100)
                .foregroundColor(Color(hikerBackgroundColor))
            
            HStack {
                Text("Event")
                    .font(.custom("Georgia", size: 40))
                    .bold()
                    .padding(.top, 100)
                    .foregroundColor(Color(hikerBackgroundColor))
                
                Text("Diary")
                    .font(.custom("Georgia", size: 40))
                    .bold()
                    .padding(.top, 100)
                    .foregroundColor(Color(hikerBackgroundColor))
            }
        }
    }
}

struct CredentialFieldsView :  View {
    @Binding var email : String
    @Binding var password : String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 320, height: 60)
                .foregroundColor(Color.clear)
                .border(.black)
            
            TextField("Email", text: $email)
                .padding(.leading, 55)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .padding(.bottom, -1)
        .padding(.top, 80)
        ZStack {
            Rectangle()
                .frame(width: 320, height: 60)
                .foregroundColor(Color.clear)
                .border(.black)
            
            SecureField("Password", text: $password)
                .padding(.leading, 55)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .padding(.bottom, 10)
    }
}

struct SignInView :  View {
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    @State var loginFailure : Bool = false
    @State var buttonPressedStatus : Bool = false

    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    @Binding var email : String
    @Binding var password : String
        
    var body: some View {
        Button(action: {
//            guard !email.isEmpty, !password.isEmpty else {
//                return
//            }
            buttonPressedStatus = true
            
            userAuthViewModel.signIn(email: email, password: password)
            
            // Reset email and password fields after every successful login
            email = ""
            password = ""
        }, label: {
            if userAuthViewModel.loginFailure == true {
                ZStack {
                    HStack(alignment: .center) {
                        Text("Email or Password were incorrect. Try Again.")
                            .font(.system(size: 15))
                            .foregroundColor(Color.red)
                            .padding(.bottom, 100)
                    }
                    VStack {
                        Text("Sign In")
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 275, height: 50)
                            .background(Color(hikerBackgroundColor))
                            .cornerRadius(150)
                    }
                }
            }
            else {
                if buttonPressedStatus == false {
                    Text("Sign In")
                        .font(.custom("Georgia", size: 25))
                        .foregroundColor(.black)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 275, height: 50)
                        .background(Color(hikerBackgroundColor))
                        .cornerRadius(150)
                }
                else {
                    VStack {
                        ProgressView("Signing in ...")
                            .padding(.bottom, 5)
                        
                        Text("Sign In")
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
        })
    }
}

struct SignUpView : View {
    @State var email : String
    @State var password : String
    
    let hikerBackgroundColor : UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    var body: some View {
        HStack {
            Text("Don't have an account?")
                .font(.custom("Georgia", size: 20))
            
            Button {
                
            } label: {
                NavigationLink(destination: RegisterUserView(email: email,
                                                             password: password),
                               label: {
                    Text("Sign Up")
                        .font(.custom("Georgia", size: 20))
                        .foregroundColor(Color(hikerBackgroundColor))
                        .font(.headline)
                        .fontWeight(.bold)
                })
            }
        }
        Spacer()
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginPageView()
        }
        .environmentObject(EventListViewModel())
        .environmentObject(UserAuthViewModel())
    }
}
