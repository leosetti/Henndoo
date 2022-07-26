//
//  SignupView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            ScrollView{
                SignupText()
                SignupForm()
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

struct SignupText: View {
    var label: LocalizedStringKey = "signup"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct SignupForm: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var username: String = ""
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var password: String = ""
    @State var email: String = ""
    
    var unamelabel: LocalizedStringKey = "username"
    var fnamelabel: LocalizedStringKey = "firstname"
    var lnamelabel: LocalizedStringKey = "lastname"
    var pwdlabel: LocalizedStringKey = "password"
    var emaillabel: LocalizedStringKey = "email"
    
    @State var user:User? = nil
    @EnvironmentObject var userManager: UserLoader
    
    var createUserError: LocalizedStringKey = "createUserError"
    @State var viewError: Bool = false
        
    var body: some View {
        
            TextField(emaillabel, text: $email)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            TextField(unamelabel, text: $username)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            TextField(fnamelabel, text: $firstname)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            TextField(lnamelabel, text: $lastname)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            SecureField(pwdlabel, text: $password)
                            .padding()
                            .background(lightGreyColor)
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
            
            Text(createUserError)
                .isHidden(!viewError)
            
            Button(action: {
                let body: [String: Any] = [
                    "username": username,
                    "firstname": firstname,
                    "lastname": lastname,
                    "email": email,
                    "password": password
                ]
                
                userManager.createUser(withObject: body, then: {result in
                    if case .success = result {
                        DispatchQueue.main.async() {
                            viewRouter.currentScreen = .main
                        }
                    }
                    if case .failure = result {
                        DispatchQueue.main.async() {
                            viewError = true
                        }
                    }
                })
                
            }) {
                SignupButtonContent()
            }
        }
        
    
}

struct SignupButtonContent: View {
    var loginlabel: LocalizedStringKey = "signup_action"
    
    var body: some View {
        Text(loginlabel)
            .textCase(.uppercase)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}
