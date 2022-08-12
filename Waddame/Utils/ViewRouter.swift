//
//  ViewRouter.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-24.
//


import SwiftUI

enum Screen {
    case login
    case main
    case account
}

class ViewRouter: ObservableObject {
    @Published var currentScreen: Screen = .login
    
}
