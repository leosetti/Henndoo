//
//  AccountView.swift
//  Henndoo
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userManager: UserLoader
    @StateObject private var userObject = UserObject()
    @EnvironmentObject var popUpObject: PopUpObject
    @State var isNavLinkActive : Bool = false
    
    var editlabel: LocalizedStringKey = "edit_profile"
    var changepwdlabel: LocalizedStringKey = "change_password"
    
    var body: some View {
        NavigationView {
            VStack {
                if userObject.user != nil {
                    AccountText(user: userObject.user!)
                    
                    Button(action: {
                        openSettings()
                    }) {
                        InfoLinkContent()
                    }
                    
                    if viewRouter.currentScreen != .account {
                        NavView(content: {EditProfileView()}, text: editlabel, type: .button, isActive: self.isNavLinkActive)
                    }
                
                    Button(action: {
                        popUpObject.type = .warning
                        popUpObject.message = "popup_logout_message"
                        popUpObject.show.toggle()
                        popUpObject.handler = {
                            userManager.logoutUser()
                            viewRouter.currentScreen = .login
                        }
                    }) {
                        GenericButtonView(label: "logout_action")
                    }
                    Button(action: {
                        popUpObject.type = .warning
                        popUpObject.message = "popup_close_account_message"
                        popUpObject.show.toggle()
                        popUpObject.handler = {
                            deleteAccount()
                        }
                    }) {
                        CloseAccountContent()
                    }
                }
            }
            .padding()
            .onAppear(){
                if viewRouter.currentScreen != .account {
                    viewRouter.currentScreen = .main
                }
                userManager.getUser(withID: "self", then: { result in
                    switch result {
                        case .success(let userFromResult):
                        userObject.user = userFromResult
                        case .failure(let error):
                            if AppUtil.isInDebugMode {
                                print(error.localizedDescription)
                            }
                        }
                })
            }
        }.environmentObject(userObject)
    }
    
    private func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    private func deleteAccount() {
        if AppUtil.isInDebugMode {
            print("Deleting account!")
        }
        
        userManager.deleteUser(then: {
            result in
            if case .success = result {
                if AppUtil.isInDebugMode {
                    print("Account deleted")
                }
                DispatchQueue.main.async() {
                    popUpObject.type = .success
                    popUpObject.message = "popup_account_deleted"
                    popUpObject.handler = {}
                    popUpObject.show.toggle()
                    viewRouter.currentScreen = .login
                }
            }
            if case .failure = result {
                DispatchQueue.main.async() {
                    if AppUtil.isInDebugMode {
                        print("Error deleting account")
                    }
                }
            }
        })
        viewRouter.currentScreen = .login
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(UserLoader())
    }
}

fileprivate struct InfoLinkContent: View {
    var label: LocalizedStringKey = "open_settings"
    
    var body: some View {
        Text(label)
            .padding()
    }
}

fileprivate struct AccountText: View {
    var user: User
    
    var label: LocalizedStringKey = "my_account"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
        Text("\(user.firstname) \(user.lastname)")
            .font(.body)
            .padding(.bottom, 7)
        Text(user.username)
            .font(.body)
            .padding(.bottom, 7)
        Text(user.email)
            .font(.body)
            .padding(.bottom, 20)
    }
}

fileprivate struct CloseAccountContent: View {
    var label: LocalizedStringKey = "account_close"
    
    var body: some View {
        Text(label)
            .textCase(.uppercase)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 40)
            .background(Color.red)
            .cornerRadius(15.0)
    }
}
