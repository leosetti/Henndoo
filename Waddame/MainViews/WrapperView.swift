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
    
    var loadinglabel: LocalizedStringKey = "loading"
    
    var body: some View {
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
    }
    
    private func handleActive() {
        validateUserToken() {
            value in
            
            if AppUtil.isInDebugMode {
                print("Token valid = \(value)")
            }
            if value {
                findUser(id: "self") {
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
        userLoader.getUserToken(withID: "self", then: { result in
            switch result {
                case .success(let tokenInResult):
                
                let epochTime = TimeInterval(tokenInResult.iat) / 1000
                let myDate = Date(timeIntervalSince1970: epochTime)
                if AppUtil.isInDebugMode {
                    print("Token date : \(myDate)")
                }
                
                var validInterval:Double = 60 * 30
                if AppUtil.isInDebugMode {
                    validInterval = 60
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
                
                case .failure(_):
                    DispatchQueue.main.async() {
                        completion(false)
                    }
                }
        })
    }
    
    private func findUser(id: String, completion: @escaping (Bool) -> Void) {
        userLoader.getUser(withID: id, then: { result in
            if case .success = result {
                DispatchQueue.main.async() {
                    completion(true)
                }
            }
            if case .failure = result {
                DispatchQueue.main.async() {
                    completion(false)
                }
            }
        })
    }
}

struct WrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView(viewRouter: ViewRouter())
    }
}



