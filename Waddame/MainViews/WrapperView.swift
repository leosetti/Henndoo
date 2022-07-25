//
//  WrapperView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-23.
//

import SwiftUI

struct WrapperView: View {
    @State var currentPage: Page = .page1
    @StateObject var viewRouter: ViewRouter
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var userLoader = UserLoader()
    @State private var logged: Bool?
    
    var loadinglabel: LocalizedStringKey = "loading"
    
    var body: some View {
        Group {
            if let loggedIn: Bool = logged {
                switch viewRouter.currentPage {
                case .page1:
                    LoginView(viewRouter: viewRouter)
                case .page2:
                    MainView(viewRouter: viewRouter)
                }
            }
            else {
                Text(loadinglabel)
            }
        }.onAppear() {
            handleActive()
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                handleActive()
            }
        }
        .environmentObject(userLoader)
    }
    
    private func handleActive() {
        findUser(id: "self") {
            value in logged = value
        }
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



