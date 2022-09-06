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
    var resetlabel: LocalizedStringKey = "forgot_password"
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    LoginText()
                    WelcomeImage()
                    if viewRouter.currentScreen == .resetPassword {
                        NavView(content: {ResetPasswordView(isActive: false)}, text: resetlabel, isActive: true)
                    }else{
                        NavView(content: {ResetPasswordView()}, text: resetlabel)
                    }
                    LoginForm()
                    NavView(content: {SignupView()}, text: signuplabel)
                }.padding()
            }
        }.environmentObject(userObject)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

fileprivate struct LoginText: View {
    var label: LocalizedStringKey = "login"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

fileprivate struct WelcomeImage: View {
    var body: some View {
        Image("userImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 20)
    }
}

fileprivate struct LoginForm: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userManager: UserLoader
    @EnvironmentObject var popUpObject: PopUpObject
    
    @State var login: String = ""
    @State var password: String = ""
    
    var loginlabel: LocalizedStringKey = "login"
    var pwdlabel: LocalizedStringKey = "password"
    
    @State var errorMesageString: LocalizedStringKey = "loginError"
    
    enum Field: Hashable {
        case login
        case password
    }
    @FocusState private var focusedField: Field?
    
    @State var loginError: LocalizedStringKey = "loginError"
    @State var viewError1: Bool = false
    @State var hasError1: Bool = false
    @State var passwordError: LocalizedStringKey = "loginError"
    @State var viewError2: Bool = false
    @State var hasError2: Bool = false
    
    var body: some View {
        VStack{
            Section{
                TextField(loginlabel, text: $login)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((hasError1 || viewError1) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .login)
                    .onSubmit {
                        viewError1 = false
                        viewError2 = false
                        hasError1 = false
                        hasError2 = false
                        if (login.count < 2 || login.count > 50) {
                            viewError1 = true
                            let l1 = 3
                            let l2 = 50
                            let st1 = String(localized: "login")
                            loginError = "form_error_1 \(st1) \(l1) \(l2)"
                            focusedField = .login
                        }else {
                            viewError1 = false
                            focusedField = .password
                        }
                    }
                Text(loginError)
                    .isHidden(!viewError1)
                    .frame(maxHeight: viewError1 ? 60 : 0)
                    .foregroundColor(.red)
                SecureField(pwdlabel, text: $password)
                    .padding()
                        .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((hasError2 || viewError2) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        viewError1 = false
                        viewError2 = false
                        hasError1 = false
                        hasError2 = false
                        if (password.count < 3 || password.count > 30) {
                            viewError2 = true
                            let l1 = 4
                            let l2 = 30
                            let st1 = String(localized: "password")
                            passwordError = "form_error_1 \(st1) \(l1) \(l2)"
                            focusedField = .password
                        }else {
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
                        "login": login,
                        "password": password
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
                                case "login":
                                    let st1 = String(localized: "login")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError1 = true
                                    focusedField = .login
                                    break
                                case "password":
                                    let st1 = String(localized: "password")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError2 = true
                                    focusedField = .password
                                    break
                                default:
                                    break
                                }
                            case UserLoader.UserError.unauthorized:
                            errorMesageString = "form_login_unauthorized"
                            break
                            
                            default:
                            errorMesageString = "loginError"
                            }
                        
                    
                        DispatchQueue.main.async() {
                            popUpObject.type = .error
                            popUpObject.message = errorMesageString
                            popUpObject.show.toggle()
                        }
                    }
                    
                    userManager.loginUser(withObject: body, then: {result in
                        switch result {
                        case .success :
                        DispatchQueue.main.async() {
                                viewRouter.currentScreen = .main
                        }
                        break
                        case .failure(let error) :
                            treatError(with: error)
                        }
                    })
                    
                }) {
                    GenericButtonView(label: "login_action")
                }
            }
        }.onAppear() {
            focusedField = .login
        }
    }
}
