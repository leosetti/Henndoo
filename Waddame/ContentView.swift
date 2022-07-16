//
//  ContentView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-15.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
struct ContentView: View {

    
    var body: some View {
        VStack {
            WelcomeText(label: "welcome")
            WelcomeImage()
            LoginForm(unamelabel: "username", pwdlabel: "password")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WelcomeText: View {
    var label: LocalizedStringKey
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
            .padding(.bottom, 75)
    }
}

struct LoginForm: View {
    @State var username: String = ""
    @State var password: String = ""
    
    var unamelabel: LocalizedStringKey
    var pwdlabel: LocalizedStringKey
    

    var body: some View {
        TextField(unamelabel, text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
        SecureField(pwdlabel, text: $password)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
        Button(action: {print("Button tapped")}) {
            LoginButtonContent(loginlabel: "login")
        }
        
    }
}

struct LoginButtonContent: View {
    var loginlabel: LocalizedStringKey
    
    var body: some View {
        Text(loginlabel)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}
