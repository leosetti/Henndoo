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
    
    var createUserError: LocalizedStringKey = "createUserError"
    @State var viewError: Bool = false
        
    var body: some View {
        
        ZStack{
            VStack{
                TextField(emaillabel, text: $email)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                TextField(unamelabel, text: $username)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                TextField(fnamelabel, text: $firstname)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                TextField(lnamelabel, text: $lastname)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                
                if type == .signup {
                    SecureField(pwdlabel, text: $password)
                                    .padding()
                                    .background(lightGreyColor)
                                    .cornerRadius(5.0)
                                    .padding(.bottom, 20)
                }
                
                Text(createUserError)
                    .isHidden(!viewError)
                
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
                if didFinishEditing {
                    popToRoot()
                }
            })
        }
        
    }
        
    private func signupUser(withBody body:[String: Any] ) {
        userManager.createUser(withObject: body, then: {result in
            if case .success = result {
                popToRoot()
            }
            if case .failure = result {
                DispatchQueue.main.async() {
                    viewError = true
                }
            }
        })
    }
    
    private func popToRoot() {
        viewRouter.currentScreen = .main
        self.rootIsActive = false
    }
    
    private func editUser(withBody body:[String: Any] ) {
        userManager.editUser(withObject: body, then: {result in
            if case .success = result {
                DispatchQueue.main.async() {
                self.didFinishEditing = true
                    popUpObject.title = "popup_account_success"
                    popUpObject.message = "popup_account_message"
                    popUpObject.show.toggle()
                }
            }
            if case .failure = result {
                DispatchQueue.main.async() {
                    viewError = true
                }
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
