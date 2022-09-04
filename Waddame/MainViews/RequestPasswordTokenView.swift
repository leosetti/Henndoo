//
//  RequestPasswordTokenView.swift
//  Waddame
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
    @EnvironmentObject var popUpObject: PopUpObject
    @EnvironmentObject var userManager: UserLoader
    
    @State var email: String = ""
    
    var title: LocalizedStringKey = "email"
    
    var body: some View {
        TextField(title, text: $email)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
        Button(action: {
            var body: [String: Any] = [:]
            body["login"] = email
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
                                    popUpObject.title = "popup_success"
                                    popUpObject.message = "password_reset_token_sent"
                                    popUpObject.show.toggle()
                                    popUpObject.handler = {
                                        
                                    }
                                    
                                }
                            }
                        } catch  {
                            DispatchQueue.main.async() {
                                popUpObject.title = "popup_error"
                                popUpObject.message = "popup_error_generic_message"
                                popUpObject.show.toggle()
                            }
                        }
                        
                    break
                    case .failure(_) :
                        DispatchQueue.main.async() {
                            popUpObject.title = "popup_error"
                            popUpObject.message = "popup_error_generic_message"
                            popUpObject.show.toggle()
                        }
                    }
                })
            }
            requestToken(withBody: body)
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
