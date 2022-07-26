//
//  ContentView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var signuplabel: LocalizedStringKey = "signup"
    
    var body: some View {
        NavigationView {
            VStack {
                LoginText()
                WelcomeImage()
                LoginForm()
                NavView(content: {SignupView()}, text: signuplabel)
            }
           
        }
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
    @State var username: String = ""
    @State var password: String = ""
    
    var unamelabel: LocalizedStringKey = "username"
    var pwdlabel: LocalizedStringKey = "password"
    

    var body: some View {
        TextField(unamelabel, text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 10)
        SecureField(pwdlabel, text: $password)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 10)
        Button(action: {print("Button tapped")}) {
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
