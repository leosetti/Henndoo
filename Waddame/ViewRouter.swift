//
//  ViewRouter.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-24.
//


import SwiftUI

enum Page {
    case page1
    case page2
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .page1
    
}
