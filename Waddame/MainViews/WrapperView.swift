//
//  WrapperView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-23.
//

import SwiftUI

struct WrapperView: View {
    @Environment(\.scenePhase) var scenePhase

    @StateObject var viewRouter: ViewRouter
    @StateObject var userLoader = UserLoader()
    @StateObject var popUpObject = PopUpObject()
    
    @State private var logged: Bool?
    @State private var showPopUp: Bool = false
    
    var loadinglabel: LocalizedStringKey = "loading"
    @State private var shortLivedSession: Bool = false
    var body: some View {
        ZStack{
            Group {
                if let _: Bool = logged {
                    switch viewRouter.currentScreen {
                    case .login:
                        LoginView()
                    case .account:
                        MainView(selectedTab: "Account")
                    default:
                        MainView()
                    }
                }
                else {
                    Text(loadinglabel)
                }
            }
            PopUpWindow(title: popUpObject.title, message: popUpObject.message, buttonText: "OK", handler: popUpObject.handler, show: $popUpObject.show)
        }.onAppear() {
            if AppUtil.isInDebugMode {
                print("WrapperView loaded")
            }
        }.onChange(of: scenePhase) { newPhase in
            switch newPhase {
                case .active :
                    if AppUtil.isInDebugMode {
                        print("WrapperView active")
                    }
                    handleActive()
                    registerSettingsBundle()
                    updateDisplayFromDefaults()
                break
                case .background:
                    if AppUtil.isInDebugMode {
                        print("App in Back ground")
                    }
                    addQuickActions()
                break
                default :
                    break
            }
            
            if AppUtil.isInDebugMode {
                print("New phase is \(newPhase)")
            }
        }
        .environmentObject(userLoader)
        .environmentObject(viewRouter)
        .environmentObject(popUpObject)
    }
    
    func addQuickActions() {
        var calluserInfo: [String: NSSecureCoding] {
            return ["name" : "profile" as NSSecureCoding]
        }
        
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(type: "Profile", localizedTitle: "shortcut_my_account", localizedSubtitle: "", icon: UIApplicationShortcutIcon(type: .contact), userInfo: calluserInfo),
        ]
    }
    
    func registerSettingsBundle(){
       let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func updateDisplayFromDefaults(){
    //Get the defaults
        let defaults = UserDefaults.standard
        let isShortLivedSession = defaults.bool(forKey: "quicklogout_preference")
        
        if AppUtil.isInDebugMode {
            print("Shortlived session = \(isShortLivedSession)")
        }
        
        shortLivedSession = isShortLivedSession
    }
    
    private func handleActive() {
        logged = nil
        validateUserToken() {
            value in
            
            if AppUtil.isInDebugMode {
                print("Token valid = \(value)")
            }
            if value {
                userLoader.findUser(id: "self") {
                    value in logged = value
                    if(value){
                        if let name = shortcutItemToProcess?.userInfo?["name"] as? String {
                            if AppUtil.isInDebugMode {
                                print("Shortcut name = \(name)")
                            }
                            switch name {
                            case "profile" :
                                viewRouter.currentScreen = .account
                                break
                            default :
                                viewRouter.currentScreen = .main
                                break
                            }
                        } else{
                            viewRouter.currentScreen = .main
                        }
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
            if shortLivedSession {
                validInterval = 60 * 10
            }
            
            if AppUtil.isInDebugMode {
                validInterval = validInterval / 10
                print("Token valid Interval : \(validInterval)")
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



