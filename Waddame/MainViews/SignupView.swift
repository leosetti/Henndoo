//
//  SignupView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct SignupView: View {
    @StateObject var viewRouter: ViewRouter
    @State var logged: Bool = false
    
    var body: some View {
        
            switch viewRouter.currentPage {
            case .page1:
                VStack {
                    SignupText()
                    SignupForm(viewRouter: viewRouter)
                }
                .padding()
            case .page2:
                MainView(viewRouter: viewRouter)
            }
        
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(viewRouter:ViewRouter())
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
    @StateObject var viewRouter: ViewRouter
    
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    
    var unamelabel: LocalizedStringKey = "username"
    var pwdlabel: LocalizedStringKey = "password"
    var emaillabel: LocalizedStringKey = "email"
    
    @State var user:User? = nil
    @State private var t1: String = ""
    @EnvironmentObject var userManager: UserLoader
        
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
        SecureField(pwdlabel, text: $password)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
        
        Text(t1)
        
        Button(action: {
            userManager.createUser(withUsername: username, withEmail: email, withPassword: password, then: {result in
                if case .success = result {
                    //DispatchQueue.main.async() {
                        viewRouter.currentPage = .page2
                    //}
                }
                if case .failure = result {
                    DispatchQueue.main.async() {
                        t1 = "Error!!"
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
