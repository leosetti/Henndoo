//
//  SignupView.swift
//  Waddame
//
//  Created by Leandro Setti de Almeida on 2022-07-16.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
        ScrollView{
            VStack {
                SignupText()
                UserForm(type:.signup)
            }.padding()
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

fileprivate struct SignupText: View {
    var label: LocalizedStringKey = "signup"
    var body: some View {
        Text(label)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}


