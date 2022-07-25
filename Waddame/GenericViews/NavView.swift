//
//  NavView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-24.
//

import SwiftUI

struct NavView<Content: View>: View {
    var content: () -> Content
    var text: LocalizedStringKey
    
    var body: some View{
        NavigationLink(destination: content()) {
            Text(text)
                .foregroundColor(.blue)
        }
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        let signuplabel: LocalizedStringKey = "signup"
        NavView(content: {SignupView(viewRouter: ViewRouter())}, text: signuplabel)
    }
}
