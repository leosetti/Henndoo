//
//  WrapperView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-23.
//

import SwiftUI

struct WrapperView: View {
    @StateObject var viewRouter: ViewRouter
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var userLoader = UserLoader()
    @State private var logged: Bool?
    
    @State private var showPopUp: Bool = false
    @StateObject var popUpObject = PopUpObject()
    
    var loadinglabel: LocalizedStringKey = "loading"
    
    var body: some View {
        ZStack{
            Group {
                if let _: Bool = logged {
                    switch viewRouter.currentScreen {
                    case .login:
                        LoginView()
                    case .main:
                        MainView()
                    }
                }
                else {
                    Text(loadinglabel)
                }
            }
            PopUpWindow(title: popUpObject.title, message: popUpObject.message, buttonText: "OK", show: $popUpObject.show)
        }.onAppear() {
            if AppUtil.isInDebugMode {
                print("WrapperView loaded")
            }
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if AppUtil.isInDebugMode {
                    print("WrapperView active")
                }
                handleActive()
            }
        }
        .environmentObject(userLoader)
        .environmentObject(viewRouter)
        .environmentObject(popUpObject)
    }
    
    private func handleActive() {
        validateUserToken() {
            value in
            
            if AppUtil.isInDebugMode {
                print("Token valid = \(value)")
            }
            if value {
                userLoader.findUser(id: "self") {
                    value in logged = value
                    if(value){
                        viewRouter.currentScreen = .main
                    }else{
                        viewRouter.currentScreen = .login
                    }
                }
            }else{
                logged = false
                viewRouter.currentScreen = .login
            }
        }
    }
    
    private func validateUserToken(completion: @escaping (Bool) -> Void) {
        let token = userLoader.getUserToken()
        if(token == nil){
            DispatchQueue.main.async() {
                completion(false)
            }
        }else{
            let epochTime = TimeInterval(token!.iat) / 1000
            let myDate = Date(timeIntervalSince1970: epochTime)
            if AppUtil.isInDebugMode {
                print("Token date : \(myDate)")
            }
            
            var validInterval:Double = 60 * 30
            if AppUtil.isInDebugMode {
                validInterval = 60 * 3
            }
            
            let lastValidDate = myDate.addingTimeInterval(validInterval)
            if AppUtil.isInDebugMode {
                print("Last valid date for token : \(lastValidDate)")
            }
            
            if Date.now < lastValidDate {
                DispatchQueue.main.async() {
                    completion(true)
                }
            }else{
                DispatchQueue.main.async() {
                    completion(false)
                }
            }
        }
    }
}

struct WrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView(viewRouter: ViewRouter())
    }
}



