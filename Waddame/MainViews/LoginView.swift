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
            ScrollView{
                VStack {
                    LoginText()
                    WelcomeImage()
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
    @State var passwordError: LocalizedStringKey = "loginError"
    @State var viewError2: Bool = false
    
    var body: some View {
        VStack{
            Section{
                TextField(loginlabel, text: $login)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                    .focused($focusedField, equals: .login)
                    .onSubmit {
                        if login.count < 2 {
                            viewError1 = true
                            loginError = "form_login_error_1"
                        }else if login.count > 50 {
                            viewError1 = true
                            loginError = "form_login_error_2"
                        }else {
                            viewError1 = false
                            focusedField = .password
                        }
                    }
                Text(loginError)
                    .isHidden(!viewError1)
                    .frame(maxHeight: viewError1 ? 30 : 0)
                    .foregroundColor(.red)
                SecureField(pwdlabel, text: $password)
                    .padding()
                        .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        if password.count < 3 {
                            viewError2 = true
                            passwordError = "form_password_error_1"
                        }else if password.count > 30 {
                            viewError2 = true
                            passwordError = "form_password_error_2"
                        }else {
                            viewError2 = false
                        }
                    }
                Text(passwordError)
                    .isHidden(!viewError2)
                    .frame(maxHeight: viewError2 ? 30 : 0)
                    .foregroundColor(.red)
            }
            Section{
                Button(action: {
                    let body: [String: Any] = [
                        "login": login,
                        "password": password
                    ]
                    
                    func treatError (with error:Error){
                        if AppUtil.isInDebugMode {
                            print(error.localizedDescription)
                        }
                        switch error {
                            case UserLoader.UserError.data(let path):
                                switch path {
                                case "login":
                                    errorMesageString = "form_login_error"
                                case "password":
                                    errorMesageString = "form_password_error"
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
                            popUpObject.title = "popup_error"
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
                    LoginButtonContent()
                }
            }
        }.onAppear() {
            focusedField = .login
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
