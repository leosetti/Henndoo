//
//  ContentView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var userObject = UserObject()
    
    var signuplabel: LocalizedStringKey = "signup"
    
    var body: some View {
        NavigationView {
            VStack {
                LoginText()
                WelcomeImage()
                LoginForm()
                NavView(content: {SignupView()}, text: signuplabel)
            }.padding()
        }.environmentObject(userObject)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct LoginText: View {
    var label: LocalizedStringKey = "login"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct WelcomeImage: View {
    var body: some View {
        Image("userImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 50)
    }
}

struct LoginForm: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userManager: UserLoader
    
    @State var login: String = ""
    @State var password: String = ""
    
    var loginlabel: LocalizedStringKey = "login"
    var pwdlabel: LocalizedStringKey = "password"
    
    var loginError: LocalizedStringKey = "loginError"
    @State var viewError: Bool = false
    
    var body: some View {
        TextField(loginlabel, text: $login)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 10)
        SecureField(pwdlabel, text: $password)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 10)
        
        Text(loginError)
            .isHidden(!viewError)
        
        Button(action: {
            let body: [String: Any] = [
                "login": login,
                "password": password
            ]
            
            userManager.loginUser(withObject: body, then: {result in
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
            LoginButtonContent()
        }
        
    }
}

struct LoginButtonContent: View {
    var loginlabel: LocalizedStringKey = "login_action"
    
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
