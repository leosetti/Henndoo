//
//  AccountView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userManager: UserLoader
    @StateObject private var userObject = UserObject()
    
    var editlabel: LocalizedStringKey = "edit_profile"
    
    var body: some View {
        NavigationView {
            VStack {
                if userObject.user != nil {
                    AccountText(user: userObject.user!)
                    NavView(content: {EditView()}, text: editlabel)
                }
                Button(action: {
                    userManager.logoutUser()
                    viewRouter.currentScreen = .login
                }) {
                    LogoutButtonContent()
                }
            }
            .padding()
            .onAppear(){
                userManager.getUser(withID: "self", then: { result in
                    switch result {
                        case .success(let userFromResult):
                        userObject.user = userFromResult
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                })
            }
        }.environmentObject(userObject)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
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

fileprivate struct LogoutButtonContent: View {
    var loginlabel: LocalizedStringKey = "logout_action"
    
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
