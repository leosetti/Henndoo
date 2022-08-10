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
    
    @Binding var rootIsActive : Bool
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
    @State var usernameError: LocalizedStringKey = "createUserError"
    @State var viewError2: Bool = false
    @State var firstnameError: LocalizedStringKey = "createUserError"
    @State var viewError3: Bool = false
    @State var lastnameError: LocalizedStringKey = "createUserError"
    @State var viewError4: Bool = false
    @State var passwordError: LocalizedStringKey = "createUserError"
    @State var viewError5: Bool = false

        
    var body: some View {
        
        ZStack{
            VStack{
                TextField(emaillabel, text: $email)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .border((errorMesageString == "form_email_error" || viewError1) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        if email.count < 2 {
                            viewError1 = true
                            emailError = "form_email_error_1"
                            focusedField = .email
                        }else if email.count > 50 {
                            viewError1 = true
                            emailError = "form_email_error_2"
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
                    .border((errorMesageString == "form_username_error" || viewError2) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .username)
                    .onSubmit {
                        if username.count < 2 {
                            viewError2 = true
                            usernameError = "form_username_error_1"
                            focusedField = .username
                        }else if username.count > 50 {
                            viewError2 = true
                            usernameError = "form_username_error_2"
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
                    .border((errorMesageString == "form_firstname_error" || viewError3) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .firstname)
                    .onSubmit {
                        if firstname.count < 2 {
                            viewError3 = true
                            firstnameError = "form_firstname_error_1"
                            focusedField = .firstname
                        }else if firstname.count > 50 {
                            viewError3 = true
                            firstnameError = "form_firstname_error_2"
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
                    .border((errorMesageString == "form_lastname_error" || viewError4) ? .red : .clear, width: 1)
                    .focused($focusedField, equals: .lastname)
                    .onSubmit {
                        if lastname.count < 2 {
                            viewError5 = true
                            lastnameError = "form_lastname_error_1"
                            focusedField = .lastname
                        }else if lastname.count > 50 {
                            viewError5 = true
                            lastnameError = "form_lastname_error_2"
                            focusedField = .lastname
                        }else {
                            viewError5 = false
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
                                    .border((errorMesageString == "form_password_error" || viewError5) ? .red : .clear, width: 1)
                                    .focused($focusedField, equals: .password)
                                    .onSubmit {
                                        if password.count < 3 {
                                            viewError5 = true
                                            passwordError = "form_password_error_1"
                                            focusedField = .password
                                        }else if password.count > 30 {
                                            viewError5 = true
                                            passwordError = "form_password_error_2"
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
        
    private func treatError (with error:Error){
        viewError1 = false
        viewError2 = false
        if AppUtil.isInDebugMode {
            print(error.localizedDescription)
        }
        switch error {
            case UserLoader.UserError.data(let path):
                switch path {
                case "email":
                    errorMesageString = "form_email_error"
                    focusedField = .email
                    break
                case "username":
                    errorMesageString = "form_username_error"
                    focusedField = .username
                    break
                case "firstname":
                    errorMesageString = "form_firstname_error"
                    focusedField = .firstname
                    break
                case "lastname":
                    errorMesageString = "form_lastname_error"
                    focusedField = .lastname
                    break
                case "password":
                    errorMesageString = "form_password_error"
                    focusedField = .password
                    break
                default:
                    break
                }
            
            default:
            errorMesageString = "createUserError"
            }
        
    
        DispatchQueue.main.async() {
            popUpObject.title = "popup_error"
            popUpObject.message = errorMesageString
            popUpObject.show.toggle()
        }
    }
    
    private func signupUser(withBody body:[String: Any] ) {
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
    
    private func popToRoot() {
        DispatchQueue.main.async() {
            viewRouter.currentScreen = .main
            self.rootIsActive = false
        }
    }
    
    private func editUser(withBody body:[String: Any] ) {
        userManager.editUser(withObject: body, then: {result in
            switch result {
            case .success :
                DispatchQueue.main.async() {
                    self.didFinishEditing = true
                    popUpObject.title = "popup_account_success"
                    popUpObject.message = "popup_account_message"
                    popUpObject.show.toggle()
                }
            break
            case .failure(let error) :
                treatError(with: error)
            }
        })
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
