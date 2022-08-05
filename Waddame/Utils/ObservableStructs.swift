//
//  ObservableStructs.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-08-05.
//

import Foundation
import SwiftUI

class UserObject: ObservableObject {
    @Published var user: User? = nil
}

class PopUpObject: ObservableObject {
    @Published var show: Bool = false
    @Published var title: LocalizedStringKey = ""
    @Published var message: LocalizedStringKey = ""
}

