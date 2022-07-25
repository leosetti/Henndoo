//
//  WaddameApp.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-15.
//

import SwiftUI

@main
struct WaddameApp: App {
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            WrapperView(viewRouter: viewRouter)
        }
    }
}
