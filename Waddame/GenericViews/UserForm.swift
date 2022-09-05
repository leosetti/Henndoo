//
//  UserForm.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-08-04.
//

import SwiftUI

enum UserFormContext {
    case signup
    case edit
}

struct UserForm: View {
    @State private var didFinishEditing: Bool = false
    
    var type: UserFormContext = .signup
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userManager: UserLoader
    @EnvironmentObject var userObject: UserObject
    @EnvironmentObject var popUpObject: PopUpObject
        
    @State var username: String = ""
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var password: String = ""
    @State var email: String = ""
    
    var unamelabel: LocalizedStringKey = "username"
    var fnamelabel: LocalizedStringKey = "firstname"
    var lnamelabel: LocalizedStringKey = "lastname"
    var pwdlabel: LocalizedStringKey = "password"
    var emaillabel: LocalizedStringKey = "email"
    
    @State var errorMesageString: LocalizedStringKey = "createUserError"
    
    enum Field: Hashable {
        case email
        case username
        case firstname
        case lastname
        case password
    }
    @FocusState private var focusedField: Field?
    
    @State var emailError: LocalizedStringKey = "createUserError"
    @State var viewError1: Bool = false
    @State var hasError1: Bool = false
    @State var usernameError: LocalizedStringKey = "createUserError"
    @State var viewError2: Bool = false
    @State var hasError2: Bool = false
    @State var firstnameError: LocalizedStringKey = "createUserError"
    @State var viewError3: Bool = false
    @State var hasError3: Bool = false
    @State var lastnameError: LocalizedStringKey = "createUserError"
    @State var viewError4: Bool = false
    @State var hasError4: Bool = false
    @State var passwordError: LocalizedStringKey = "createUserError"
    @State var viewError5: Bool = false
    @State var hasError5: Bool = false

    func popToRoot() {
        DispatchQueue.main.async() {
            viewRouter.currentScreen = .main
        }
    }
        
    var body: some View {
        ZStack{
            VStack{
                TextField(emaillabel, text: $email)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((hasError1 || viewError1) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        if (email.count < 2 || email.count > 50) {
                            viewError1 = true
                            viewError2 = false
                            viewError3 = false
                            viewError4 = false
                            viewError5 = false
                            let l1 = 3
                            let l2 = 50
                            let st1 = String(localized: "email")
                            emailError = "form_error_1 \(st1) \(l1) \(l2)"
                            focusedField = .email
                        }else {
                            viewError1 = false
                            focusedField = .username
                        }
                    }
                Text(emailError)
                    .isHidden(!viewError1)
                    .frame(maxHeight: viewError1 ? 30 : 0)
                    .foregroundColor(.red)
                TextField(unamelabel, text: $username)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((hasError2 || viewError2) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .username)
                    .onSubmit {
                        viewError1 = false
                        viewError2 = false
                        viewError3 = false
                        viewError4 = false
                        viewError5 = false
                        hasError1 = false
                        hasError2 = false
                        hasError3 = false
                        hasError4 = false
                        hasError5 = false
                        if (username.count < 2 || username.count > 50) {
                            viewError2 = true
                            let l1 = 3
                            let l2 = 50
                            let st1 = String(localized: "username")
                            usernameError = "form_error_1 \(st1) \(l1) \(l2)"
                            focusedField = .username
                        }else {
                            viewError2 = false
                            focusedField = .firstname
                        }
                    }
                Text(usernameError)
                    .isHidden(!viewError2)
                    .frame(maxHeight: viewError2 ? 30 : 0)
                    .foregroundColor(.red)
                TextField(fnamelabel, text: $firstname)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((hasError3 || viewError3) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .firstname)
                    .onSubmit {
                        viewError1 = false
                        viewError2 = false
                        viewError3 = false
                        viewError4 = false
                        viewError5 = false
                        hasError1 = false
                        hasError2 = false
                        hasError3 = false
                        hasError4 = false
                        hasError5 = false
                        if (firstname.count < 2 || firstname.count > 50) {
                            viewError3 = true
                            let l1 = 3
                            let l2 = 50
                            let st1 = String(localized: "firstname")
                            firstnameError = "form_error_1 \(st1) \(l1) \(l2)"
                            focusedField = .firstname
                        }else {
                            viewError3 = false
                            focusedField = .lastname
                        }
                    }
                Text(firstnameError)
                    .isHidden(!viewError3)
                    .frame(maxHeight: viewError3 ? 30 : 0)
                    .foregroundColor(.red)
                TextField(lnamelabel, text: $lastname)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((hasError4 || viewError4) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .lastname)
                    .onSubmit {
                        viewError1 = false
                        viewError2 = false
                        viewError3 = false
                        viewError4 = false
                        viewError5 = false
                        hasError1 = false
                        hasError2 = false
                        hasError3 = false
                        hasError4 = false
                        hasError5 = false
                        if lastname.count < 2 || lastname.count > 50 {
                            viewError4 = true
                            let l1 = 3
                            let l2 = 50
                            let st1 = String(localized: "lastname")
                            lastnameError = "form_error_1 \(st1) \(l1) \(l2)"
                            focusedField = .lastname
                        }else {
                            viewError4 = false
                            if type == .signup {
                                focusedField = .password
                            }
                        }
                    }
                Text(lastnameError)
                    .isHidden(!viewError4)
                    .frame(maxHeight: viewError4 ? 30 : 0)
                    .foregroundColor(.red)
                
                if type == .signup {
                    SecureField(pwdlabel, text: $password)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .border((hasError5 || viewError5) ? .red : .clear, width: 1)
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            viewError1 = false
                            viewError2 = false
                            viewError3 = false
                            viewError4 = false
                            viewError5 = false
                            hasError1 = false
                            hasError2 = false
                            hasError3 = false
                            hasError4 = false
                            hasError5 = false
                            if (password.count < 3 || password.count > 30) {
                                viewError5 = true
                                let l1 = 4
                                let l2 = 30
                                let st1 = String(localized: "password")
                                passwordError = "form_error_1 \(st1) \(l1) \(l2)"
                                focusedField = .password
                            }else {
                                viewError5 = false
                            }
                        }
                    Text(passwordError)
                        .isHidden(!viewError5)
                        .frame(maxHeight: viewError5 ? 30 : 0)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    var body: [String: Any] = [:]
                    
                    if username != "" {
                        body["username"] = username
                    }
                    
                    if firstname != "" {
                        body["firstname"] = firstname
                    }
                    
                    if lastname != "" {
                        body["lastname"] = lastname
                    }
                    
                    if email != "" {
                        body["email"] = email
                    }
                    
                    if type == .signup {
                        body["password"] = password
                    }
                    
                    func treatError (with error:Error){
                        viewError1 = false
                        viewError2 = false
                        viewError3 = false
                        viewError4 = false
                        viewError5 = false
                        hasError1 = false
                        hasError2 = false
                        hasError3 = false
                        hasError4 = false
                        hasError5 = false
                        if AppUtil.isInDebugMode {
                            print(error.localizedDescription)
                        }
                        switch error {
                            case UserLoader.UserError.data(let path):
                                switch path {
                                case "email":
                                    let st1 = String(localized: "email")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError1 = true
                                    focusedField = .email
                                    break
                                case "username":
                                    let st1 = String(localized: "username")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError2 = true
                                    focusedField = .username
                                    break
                                case "firstname":
                                    let st1 = String(localized: "firstname")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError3 = true
                                    focusedField = .firstname
                                    break
                                case "lastname":
                                    let st1 = String(localized: "lastname")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError4 = true
                                    focusedField = .lastname
                                    break
                                case "password":
                                    let st1 = String(localized: "password")
                                    errorMesageString = "form_error_2 \(st1)"
                                    hasError5 = true
                                    focusedField = .password
                                    break
                                default:
                                    break
                                }
                            
                            default:
                            errorMesageString = "createUserError"
                        }
                        
                    
                        DispatchQueue.main.async() {
                            popUpObject.type = .error
                            popUpObject.message = errorMesageString
                            popUpObject.show.toggle()
                        }
                    }
                    
                    func signupUser(withBody body:[String: Any] ) {
                        userManager.createUser(withObject: body, then: {result in
                            switch result {
                            case .success :
                                popToRoot()
                            break
                            case .failure(let error) :
                                treatError(with: error)
                            }
                        })
                    }
                    
                    func editUser(withBody body:[String: Any] ) {
                        userManager.editUser(withObject: body, then: {result in
                            switch result {
                            case .success :
                                DispatchQueue.main.async() {
                                    self.didFinishEditing = true
                                    popUpObject.type = .success
                                    popUpObject.message = "popup_account_message"
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
                    }
                    
                    switch type {
                    case .signup:
                        signupUser(withBody: body)
                    case .edit:
                        editUser(withBody: body)
                    }

                }) {
                switch type {
                    case .signup:
                        SignupButtonContent()
                    case .edit:
                        EditButtonContent()
                    }
                }
            }.onAppear() {
                username = userObject.user?.username ?? ""
                firstname = userObject.user?.firstname ?? ""
                lastname = userObject.user?.lastname ?? ""
                email = userObject.user?.email ?? ""
            }.onChange(of: popUpObject.show, perform: {newValue in
                if !popUpObject.show && didFinishEditing {
                    popToRoot()
                }
            })
        }
    
        
    }
}


 
fileprivate struct SignupButtonContent: View {
    var label: LocalizedStringKey = "signup_action"
    
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

fileprivate struct EditButtonContent: View {
    var label: LocalizedStringKey = "edit_action"
    
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
