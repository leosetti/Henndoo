//
//  RequestPasswordTokenView.swift
//  Henndoo
//
//  Created by Leandro Setti de Almeida on 2022-09-04.
//

import SwiftUI

struct RequestPasswordTokenView: View {    
    var body: some View {
        VStack{
            ResetText()
            ResetForm()
        }.padding()
    }
}

struct RequestPasswordTokenView_Previews: PreviewProvider {
    static var previews: some View {
        RequestPasswordTokenView()
    }
}


fileprivate struct ResetText: View {
    var title: LocalizedStringKey = "password_reset_request_title"
    var label: LocalizedStringKey = "password_reset_request_instruction"
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
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var popUpObject: PopUpObject
    @EnvironmentObject var userManager: UserLoader
    
    @State var login: String = ""
    
    var title: LocalizedStringKey = "login"
    
    var body: some View {
        TextField(title, text: $login)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
        Button(action: {
            var body: [String: Any] = [:]
            body["login"] = login
            body["language"] = Locale.current.languageCode
            
            func requestToken(withBody body:[String: Any] ) {
                userManager.requestUserPasswordToken(withObject: body, then: {result in
                    switch result {
                    case .success :
                        if AppUtil.isInDebugMode {
                            print("Result = \(result)")
                        }
                        
                        do {
                            let res = try result.get()
                            if res.code == "OK" {
                                DispatchQueue.main.async() {
                                    popUpObject.type = .success
                                    popUpObject.message = "password_reset_token_sent"
                                    popUpObject.show.toggle()
                                    popUpObject.handler = {
                                        viewRouter.currentScreen = .resetPassword(token: "")
                                    }
                                }
                            }
                        } catch  {
                            DispatchQueue.main.async() {
                                popUpObject.type = .error
                                popUpObject.message = "popup_error_generic_message"
                                popUpObject.show.toggle()
                            }
                        }
                        
                    break
                    case .failure(_) :
                        DispatchQueue.main.async() {
                            popUpObject.type = .error
                            popUpObject.message = "popup_error_generic_message"
                            popUpObject.show.toggle()
                        }
                    }
                })
            }
            requestToken(withBody: body)
        }) {
            GenericButtonView(label: "submit")
                .padding(.top, 20)
        }
    }
}
