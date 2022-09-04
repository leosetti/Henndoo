//
//  ResetPasswordView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-09-04.
//

import SwiftUI

struct ResetPasswordView: View {
    var label: LocalizedStringKey = "password_reset_request"
    
    var body: some View {
        VStack{
            ResetText()
            ResetForm()
            NavView(content: {RequestPasswordTokenView()}, text: label)
        }.padding()
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}

fileprivate struct ResetText: View {
    var title: LocalizedStringKey = "password_reset_title"
    var label: LocalizedStringKey = "password_reset_label"
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 10)
        Text(label)
            .font(.body)
            .fontWeight(.regular)
            .padding(.bottom, 20)
    }
}

fileprivate struct ResetForm: View {
    @EnvironmentObject var popUpObject: PopUpObject
    @State var token: String = ""
    
    var title: LocalizedStringKey = "password_reset_token"
    
    var body: some View {
        TextField(title, text: $token)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
        Button(action: {
            DispatchQueue.main.async() {
                popUpObject.title = "popup_error"
                popUpObject.message = "createUserError"
                popUpObject.show.toggle()
            }
        }) {
            ButtonContent()
        }
    }
}

fileprivate struct ButtonContent: View {
    var label: LocalizedStringKey = "submit"
    
    var body: some View {
        Text(label)
            .textCase(.uppercase)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}
