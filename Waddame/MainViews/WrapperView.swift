//
//  WrapperView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-23.
//

import SwiftUI

struct WrapperView: View {
    @StateObject var userLoader = UserLoader()
    @State private var logged: Bool?
    
    var body: some View {
        Group {
            if let loggedIn: Bool = logged {
                if loggedIn {
                    MainView()
                }
                else {
                    LoginView()
                }
            }
            else {
                Text("loading...")
            }
        }.onAppear() {
            findUser(id: "self") {
                value in logged = value
            }
        }
    }
    
    func findUser(id: String, completion: @escaping (Bool) -> Void) {
        
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
        WrapperView()
    }
}



