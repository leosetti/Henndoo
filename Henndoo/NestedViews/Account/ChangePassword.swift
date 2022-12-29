//
//  ChangePassword.swift
//  Henndoo
//
//  Created by Leandro Setti de Almeida on 2022-08-10.
//

import SwiftUI

struct ChangePassword: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var userObject = UserObject()
    
    var signuplabel: LocalizedStringKey = "signup"
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    TitleText()
                    PasswordForm()
                }.padding()
            }
        }.environmentObject(userObject)
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

fileprivate struct TitleText: View {
    var label: LocalizedStringKey = "change_password"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

fileprivate struct PasswordForm: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userManager: UserLoader
    @EnvironmentObject var popUpObject: PopUpObject
    
    @State var oldpassword: String = ""
    @State var newpassword: String = ""
    
    var oldpwdlabel: LocalizedStringKey = "old_password"
    var pwdlabel: LocalizedStringKey = "new_password"
    
    @State var errorMesageString: LocalizedStringKey = "popup_error"
    
    enum Field: Hashable {
        case oldpassword
        case newpassword
    }
    @FocusState private var focusedField: Field?
    
    @State var oldpasswordError: LocalizedStringKey = "form_password_error"
    @State var viewError1: Bool = false
    @State var hasError1: Bool = false
    @State var passwordError: LocalizedStringKey = "form_password_error"
    @State var viewError2: Bool = false
    @State var hasError2: Bool = false
    
    var body: some View {
        VStack{
            Section{
                SecureField(oldpwdlabel, text: $oldpassword)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((hasError1 || viewError1) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .oldpassword)
                    .onSubmit {
                        if (oldpassword.count < 3 || oldpassword.count > 30) {
                            viewError1 = true
                            viewError2 = false
                            let l1 = 3
                            let l2 = 50
                            let st1 = String(localized: "old_password")
                            oldpasswordError = "form_error_1 \(st1) \(l1) \(l2)"
                            focusedField = .oldpassword
                        }else {
                            viewError1 = false
                            focusedField = .newpassword
                        }
                    }
                Text(oldpasswordError)
                    .isHidden(!viewError1)
                    .frame(maxHeight: viewError1 ? 60 : 0)
                    .foregroundColor(.red)
                SecureField(pwdlabel, text: $newpassword)
                    .padding()
                        .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((hasError2 || viewError2) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .newpassword)
                    .onSubmit {
                        if (newpassword.count < 3 ||  newpassword.count > 30) {
                            viewError2 = true
                            viewError1 = false
                            let l1 = 4
                            let l2 = 30
                            let st1 = String(localized: "new_password")
                            passwordError = "form_error_1 \(st1) \(l1) \(l2)"
                            focusedField = .newpassword
                        } else {
                            viewError2 = false
                        }
                    }
                Text(passwordError)
                    .isHidden(!viewError2)
                    .frame(maxHeight: viewError2 ? 60 : 0)
                    .foregroundColor(.red)
            }
            Section{
                Button(action: {
                    let body: [String: Any] = [
                        "oldpassword": oldpassword,
                        "newpassword": newpassword
                    ]
                    
                    func treatError (with error:Error){
                        viewError1 = false
                        viewError2 = false
                        hasError1 = false
                        hasError2 = false
                        if AppUtil.isInDebugMode {
                            print(error.localizedDescription)
                        }
                        switch error {
                            case UserLoader.UserError.data(let path):
                                switch path {
                                case "oldpassword":
                                    let st1 = String(localized: "old_password")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError1 = true
                                    focusedField = .oldpassword
                                    break
                                case "newpassword":
                                    let st1 = String(localized: "new_password")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError2 = true
                                    focusedField = .newpassword
                                    break
                                default:
                                    break
                                }
                            case UserLoader.UserError.unauthorized:
                            errorMesageString = "form_login_unauthorized"
                            break
                            
                            default:
                            errorMesageString = "form_password_error"
                            }
                        
                    
                        DispatchQueue.main.async() {
                            popUpObject.type = .error
                            popUpObject.message = errorMesageString
                            popUpObject.handler = {}
                            popUpObject.show.toggle()
                        }
                    }
                    
                    userManager.changeUserPassword(withObject: body, then: {result in
                        switch result {
                        case .success :
                            viewError1 = false
                            viewError2 = false
                            hasError1 = false
                            hasError2 = false
                            errorMesageString = "popup_error"
                            DispatchQueue.main.async() {
                                popUpObject.type = .success
                                popUpObject.message = "popup_account_password_changed"
                                popUpObject.handler = {
                                    viewRouter.currentScreen = .account
                                }
                                popUpObject.show.toggle()
                            }
                            break
                        case .failure(let error) :
                            treatError(with: error)
                        }
                    })
                    
                }) {
                    GenericButtonView(label: "change_action")
                }
            }
        }.onAppear() {
            focusedField = .oldpassword
        }
    }
}
